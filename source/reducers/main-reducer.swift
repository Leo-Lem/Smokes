import ComposableArchitecture
import Foundation

struct MainReducer: ReducerProtocol {
  struct State: Equatable {
    var entries: [Date]
    var amounts = [DateInterval: Int]()
    var averages = [Calendar.Component: [DateInterval: Double]]()
    var subdivisions = [Calendar.Component: [DateInterval: [DateInterval: Int]]]()
    
    var startDate: Date { entries.first ?? Dependency(\.date.now).wrappedValue }
    
    init(_ entries: [Date] = []) { self.entries = entries }
    
    func average(until date: Date, by subdivision: Calendar.Component) -> Double? {
      DateInterval(start: startDate, safeEnd: date).flatMap { averages[subdivision]?[$0] } ?? 0
    }
  }
  
  enum Action {
    case loadEntries, saveEntries
    
    case add(Date), remove(Date)
    
    case calculateAmount(DateInterval)
    
    case calculateAverage(DateInterval, Calendar.Component),
         _continueCalculatingAverage(DateInterval, Calendar.Component)
    case calculateAverageUntil(Date, Calendar.Component)
    
    case calculateSubdivision(DateInterval, Calendar.Component),
         _continueCalculatingSubdivision(DateInterval, Calendar.Component, [DateInterval])
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce<State, Action> { state, action in
      let id = "entries"
      switch action {
      case .loadEntries:
        do { state.entries ?= try persistor.read(id: id) } catch { debugPrint(error) }
        
      case .saveEntries:
        do { try persistor.write(state.entries, id: id) } catch { debugPrint(error) }
      default: break
      }
      
      switch action {
      case let .add(date):
        for interval in state.amounts.keys where interval.contains(date) { state.amounts[interval]? += 1 }
        
        for component in state.averages.keys {
          for interval in state.averages[component]!.keys where interval.contains(date) {
            let length = Dependency(\.calendar).wrappedValue
              .dateComponents([component], from: interval.start, to: interval.end).value(for: component) ?? 1
            state.averages[component]?[interval]? += 1 / Double(length == 0 ? 1 : length)
          }
        }
        
        state.entries.insert(date, at: state.entries.firstIndex { date < $0 } ?? state.entries.endIndex)
        
      case let .remove(date):
        if let index = state.entries.firstIndex(where: { $0 <= date }) {
          for interval in state.amounts.keys where interval.contains(date) { state.amounts[interval]? -= 1 }
          
          for component in state.averages.keys {
            for interval in state.averages[component]!.keys where interval.contains(date) {
              let length = Dependency(\.calendar).wrappedValue
                .dateComponents([component], from: interval.start, to: interval.end).value(for: component) ?? 1
              state.averages[component]?[interval]? -= 1 / Double(length == 0 ? 1 : length)
            }
          }
          
          state.entries.remove(at: index)
        }
        
      default: break
      }
        
      if case let .calculateAmount(interval) = action {
        state.amounts[interval] = (state.entries.firstIndex { interval.end < $0 } ?? state.entries.endIndex) -
          (state.entries.firstIndex { interval.start <= $0 } ?? state.entries.endIndex)
      }
      
      switch action {
      case let .calculateAverage(interval, subdivision):
        return .run { actions in
          await actions.send(.calculateAmount(interval))
          await actions.send(._continueCalculatingAverage(interval, subdivision))
        }
        
      case let ._continueCalculatingAverage(interval, subdivision):
        if let amount = state.amounts[interval] {
          let length = Dependency(\.calendar).wrappedValue
            .dateComponents([subdivision], from: interval.start, to: interval.end).value(for: subdivision) ?? 1
          state.averages[subdivision, default: [:]][interval] = Double(amount) / Double(length == 0 ? 1 : length)
        }
        
      case let .calculateAverageUntil(date, subdivision):
        if let interval = DateInterval(start: state.startDate, safeEnd: date) {
          return .send(.calculateAverage(interval, subdivision))
        }
        
      default: break
      }
      
      switch action {
      case let .calculateSubdivision(interval, component):
        return .run { actions in
          @Dependency(\.calendar) var cal: Calendar
          var subintervals = [DateInterval](), date = interval.start
              
          while date < interval.end {
            let nextDate = cal.date(byAdding: component, value: 1, to: date)!,
                subinterval = DateInterval(start: date, end: nextDate)
            
            await actions.send(.calculateAmount(subinterval))
            
            subintervals.append(subinterval)
            date = nextDate
          }
          
          await actions.send(._continueCalculatingSubdivision(interval, component, subintervals))
        }
        
      case let ._continueCalculatingSubdivision(interval, component, subintervals):
        state.subdivisions[component, default: [:]][interval] =
          .init(uniqueKeysWithValues: subintervals.map { ($0, state.amounts[$0] ?? 0) })
        
      default: break
      }
      
      return .none
    }
  }
  
  @Dependency(\.persistor) private var persistor
}

extension DateInterval {
  init?(start: Date, safeEnd: Date) {
    if start <= safeEnd { self.init(start: start, end: safeEnd) } else { return nil }
  }
}

infix operator ?=: AssignmentPrecedence
extension Optional {
  static func ?= (lhs: inout Wrapped, rhs: Wrapped?) {
    if let rhs { lhs = rhs }
  }
}
