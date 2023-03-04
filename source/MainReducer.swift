import ComposableArchitecture
import Foundation

struct MainReducer: ReducerProtocol {
  struct State: Equatable {
    var entries: [Date]
    var amounts = [DateInterval: Int]()
    
    var startDate: Date { entries.first ?? Dependency(\.date.now).wrappedValue }
    
    init(_ entries: [Date] = []) { self.entries = entries }
  }
  
  enum Action {
    case loadEntries, saveEntries
    case setEntries([Date]), addEntries([Date])
    case add(Date), remove(Date)
    
    case calculateAmount(DateInterval)
    case calculateAmountForAverageUntil(Date),
         calculateAmountForAverage(DateInterval)
    case calculateAmountForSubdivisionUntil(Date, Calendar.Component),
         calculateAmountForSubdivision(DateInterval, Calendar.Component)
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
      case let .setEntries(newEntries):
        state.entries = newEntries
        let intervals = state.amounts.keys
        return .run { actions in
          for interval in intervals { await actions.send(.calculateAmount(interval)) }
        }
        
      case let .addEntries(newEntries):
        state.entries += newEntries
        let intervals = state.amounts.keys
        return .run { actions in
          for interval in intervals { await actions.send(.calculateAmount(interval)) }
        }
        
      default: break
      }
      
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
      
      switch action {
      case let .calculateAmount(interval):
        state.amounts[interval] = (state.entries.firstIndex { interval.end < $0 } ?? state.entries.endIndex) -
          (state.entries.firstIndex { interval.start <= $0 } ?? state.entries.endIndex)
        
      case let .calculateAmountForAverageUntil(date):
        if let interval = DateInterval(start: state.startDate, safeEnd: date) {
          return .send(.calculateAmountForAverage(interval))
        }
        
      case let .calculateAmountForAverage(interval):
        return .send(.calculateAmount(interval))
        
      case let .calculateAmountForSubdivisionUntil(date, component):
        if let interval = DateInterval(start: state.startDate, safeEnd: date) {
          return .send(.calculateAmountForSubdivision(interval, component))
        }
        
      case let .calculateAmountForSubdivision(interval, component):
        return .run { actions in
          @Dependency(\.calendar) var cal: Calendar
          var date = cal.startOfDay(for: interval.start)
          while date < interval.end {
            let nextDate = cal.date(byAdding: component, value: 1, to: date)!
            await actions.send(.calculateAmount(DateInterval(start: date, end: nextDate)))
            date = nextDate
          }
        }
        
      default: break
      }
      
      return .none
    }
  }
  
  @Dependency(\.persistor) private var persistor
}

extension MainReducer.State {
  func average(until date: Date, by subdivision: Calendar.Component) -> Double? {
    DateInterval(start: startDate, safeEnd: date).flatMap { average($0, by: subdivision) } ?? 0
  }
  
  func subdivide(until date: Date, by subdivision: Calendar.Component) -> [DateInterval: Int] {
    DateInterval(start: startDate, safeEnd: date).flatMap { subdivide($0, by: subdivision) } ?? [:]
  }
  
  func average(_ interval: DateInterval, by subdivision: Calendar.Component) -> Double? {
    @Dependency(\.calendar) var cal: Calendar
    let length = cal.dateComponents([subdivision], from: interval.start, to: interval.end)
      .value(for: subdivision) ?? 1
    
    return Double(amounts[interval] ?? 0) / Double(length == 0 ? 1 : length)
  }
  
  func subdivide(_ interval: DateInterval, by subdivision: Calendar.Component) -> [DateInterval: Int] {
    @Dependency(\.calendar) var cal: Calendar
    var subintervals = [DateInterval](), date = cal.startOfDay(for: interval.start)
        
    while date < interval.end {
      let nextDate = cal.date(byAdding: subdivision, value: 1, to: date)!
      subintervals.append(DateInterval(start: date, end: nextDate))
      date = nextDate
    }
    
    return .init(uniqueKeysWithValues: subintervals.map { ($0, amounts[$0] ?? 0) })
  }
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
