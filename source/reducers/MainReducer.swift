import ComposableArchitecture
import Foundation

struct MainReducer: ReducerProtocol {
  struct State: Equatable {
    var entries: Entries.State
    var amounts = Amounts.State(), averages = Averages.State()
    
    init(_ entries: [Date]) { self.entries = .init(dates: entries) }
    
    func average(until date: Date, by subdivision: Calendar.Component) -> Double? {
      DateInterval(start: entries.startDate, safeEnd: date).flatMap { averages[$0, by: subdivision] } ?? 0
    }
  }
  
  enum Action {
    case entries(Entries.Action), amounts(Amounts.Action), averages(Averages.Action)
    
    case add(Date), remove(Date)
    
    case calculateAmount(DateInterval)
    
    case calculateAverageUntil(Date, Calendar.Component),
         calculateAverage(DateInterval, Calendar.Component),
         continueCalculatingAverage(DateInterval, Calendar.Component)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.entries, action: /Action.entries) { Entries() }
    Scope(state: \.amounts, action: /Action.amounts) { Amounts() }
    Scope(state: \.averages, action: /Action.averages) { Averages() }
    
    Reduce<State, Action> { state, action in
      switch action {
      case let .add(date):
        for interval in state.amounts.cache.keys where interval.contains(date) { state.amounts[interval]? += 1 }
        return .send(.entries(.add(date)))
        
      case let .remove(date):
        if state.entries.dates.firstIndex(where: { $0 <= date }) != nil {
          for interval in state.amounts.cache.keys where interval.contains(date) { state.amounts[interval]? -= 1 }
          return .send(.entries(.remove(date)))
        }
        
      default: break
      }
        
      return .none
    }
    
    Reduce<State, Action> { state, action in
      if case let .calculateAmount(interval) = action {
        return .send(.amounts(.calculate(interval, state.entries.dates)))
      }
        
      return .none
    }
    
    Reduce<State, Action> { state, action in
      switch action {
      case let .calculateAverageUntil(date, subdivision):
        if let interval = DateInterval(start: state.entries.startDate, safeEnd: date) {
          return .send(.calculateAverage(interval, subdivision))
        }
        
      case let .calculateAverage(interval, subdivision):
        return .run { actions in
          await actions.send(.calculateAmount(interval))
          await actions.send(.continueCalculatingAverage(interval, subdivision))
        }
        
      case let .continueCalculatingAverage(interval, subdivision):
        if let amount = state.amounts[interval] { return .send(.averages(.calculate(interval, subdivision, amount))) }
        
      default: break
      }
        
      return .none
    }
  }
}

extension DateInterval {
  init?(start: Date, safeEnd: Date) {
    if start <= safeEnd { self.init(start: start, end: safeEnd) } else { return nil }
  }
}

#if DEBUG
extension MainReducer.State {
  static var preview: Self { .init((0..<1000).map { _ in Date.now + Double.random(in: -1000_000..<1000_000) }) }
}
#endif
