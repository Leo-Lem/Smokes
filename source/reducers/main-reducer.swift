import ComposableArchitecture
import Foundation

struct MainReducer: ReducerProtocol {
  struct State: Equatable {
    var entries: [Date]
    var amounts = [DateInterval: Int]()
    var averages = [Calendar.Component: [DateInterval: Double]]()
    
    var startDate: Date { entries.first ?? Dependency(\.date.now).wrappedValue }
    
    init(_ entries: [Date] = []) { self.entries = entries }
    
    func average(until date: Date, by subdivision: Calendar.Component) -> Double? {
      DateInterval(start: startDate, safeEnd: date).flatMap { averages[subdivision]?[$0] } ?? 0
    }
  }
  
  enum Action {
    case add(Date), remove(Date)
    
    case calculateAmount(DateInterval)
    
    case calculateAverageUntil(Date, Calendar.Component),
         calculateAverage(DateInterval, Calendar.Component),
         _continueCalculatingAverage(DateInterval, Calendar.Component)
    
    case loadEntries, saveEntries
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .add(date):
        for interval in state.amounts.keys where interval.contains(date) { state.amounts[interval]? += 1 }
        state.entries.insert(date, at: state.entries.firstIndex { date < $0 } ?? state.entries.endIndex)
        
      case let .remove(date):
        if let index = state.entries.firstIndex(where: { $0 <= date }) {
          for interval in state.amounts.keys where interval.contains(date) { state.amounts[interval]? -= 1 }
          state.entries.remove(at: index)
        }
        
      default: break
      }
        
      if case let .calculateAmount(interval) = action {
        state.amounts[interval] = (state.entries.firstIndex { interval.end < $0 } ?? state.entries.endIndex) -
          (state.entries.firstIndex { interval.start <= $0 } ?? state.entries.endIndex)
      }
      
      switch action {
      case let .calculateAverageUntil(date, subdivision):
        if let interval = DateInterval(start: state.startDate, safeEnd: date) {
          return .send(.calculateAverage(interval, subdivision))
        }
        
      case let .calculateAverage(interval, subdivision):
        return .run { actions in
          await actions.send(.calculateAmount(interval))
          await actions.send(._continueCalculatingAverage(interval, subdivision))
        }
        
      case let ._continueCalculatingAverage(interval, subdivision):
        if let amount = state.amounts[interval] {
          let length = Dependency(\.calendar).wrappedValue
            .dateComponents([subdivision], from: interval.start, to: interval.end).value(for: subdivision) ?? 1
          state.averages[subdivision] = [interval: Double(amount) / Double(length == 0 ? 1 : length)]
        }
        
      default: break
      }
      
      let id = "entries"
      switch action {
      case .loadEntries:
        do { state.entries ?= try persistor.read(id: id) } catch { debugPrint(error) }
        
      case .saveEntries:
        do { try persistor.write(state.entries, id: id) } catch { debugPrint(error) }
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
