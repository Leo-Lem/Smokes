import ComposableArchitecture
import Foundation

struct MainReducer: ReducerProtocol {
  struct State: Equatable {
    var entries: Entries.State
    var amounts = Amounts.State()
    
    init(_ entries: [Date]) { self.entries = .init(dates: entries) }
    
    func amount(until date: Date) -> Int? { amounts[until: date, entries.startDate] }
  }
  
  enum Action {
    case add(Date), remove(Date)
    case calculateAmount(_ interval: DateInterval), calculateAmountUntil(Date)
    case entries(Entries.Action), amounts(Amounts.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.entries, action: /Action.entries) { Entries() }
    Scope(state: \.amounts, action: /Action.amounts) { Amounts() }
    
    Reduce { state, action in
      switch action {
      case let .add(date):
        for interval in state.amounts.cache.keys where interval.contains(date) { state.amounts[interval]? += 1 }
        return .send(.entries(.add(date)))
        
      case let .remove(date):
        if state.entries.dates.firstIndex(where: { $0 <= date }) != nil {
          for interval in state.amounts.cache.keys where interval.contains(date) { state.amounts[interval]? -= 1 }
          return .send(.entries(.remove(date)))
        }
          
      case let .calculateAmount(interval):
        return .send(.amounts(.calculate(interval, state.entries.dates)))
          
      case let .calculateAmountUntil(date):
        return .send(.amounts(.calculateUntil(date, state.entries.startDate, state.entries.dates)))
          
      default: break
      }
        
      return .none
    }
  }
}

#if DEBUG
extension MainReducer.State {
  static var preview: Self { .init((0..<1000).map { _ in Date.now + Double.random(in: -1_000_000..<1_000_000) }) }
}
#endif
