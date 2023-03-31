import ComposableArchitecture
import Foundation

struct MainReducer: ReducerProtocol {
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.entries, action: /MainReducer.Action.entries, child: Entries.init)
    Scope(state: \.filePorter, action: /MainReducer.Action.filePorter, child: FilePorter.init)
    
    Reduce<State, Action> { state, action in
      switch action {
      case let .calculateAmount(interval):
        @Dependency(\.calculator.amount) var amount
        state.amounts[interval] = amount(state.entries.unwrapped, interval)
        
      case let .calculateAmounts(interval, component):
        return .run { actions in
          @Dependency(\.calendar) var cal: Calendar
          var date = cal.startOfDay(for: interval.start)
          while date < interval.end {
            let nextDate = cal.date(byAdding: component, value: 1, to: date)!
            await actions.send(.calculateAmount(DateInterval(start: date, end: nextDate)))
            date = nextDate
          }
        }
        
      case let .entries(.updateAmounts(date)):
        let intervals = state.amounts.keys
        return .run { actions in
          if let date {
            for interval in intervals where interval.contains(date) { await actions.send(.calculateAmount(interval)) }
          } else {
            for interval in intervals { await actions.send(.calculateAmount(interval)) }
          }
        }
        
      case let .filePorter(.addEntries(entries)):
        return .send(.entries(.set((state.entries.unwrapped + entries).sorted())))
        
      default: break
      }
      return .none
    }
  }
}

extension MainReducer {
  struct State: Equatable {
    var entries = Entries.State()
    var amounts = [DateInterval: Int]()
    var filePorter = FilePorter.State()
    
    func entries(in interval: DateInterval) -> [Date] { entries.unwrapped.filter(interval.contains) }
    
    var validInterval: DateInterval {
      @Dependency(\.date.now) var now
      @Dependency(\.calendar) var cal
      return DateInterval(start: entries.startDate, end: cal.endOfDay(for: now))
    }
    
    func average(_ interval: DateInterval, by subdivision: Calendar.Component) -> Double? {
      guard let clamped = validInterval.intersection(with: interval) else { return 0 }
      guard let amount = amounts[interval] else { return nil }
      
      @Dependency(\.calculator.average) var average
      return average(amount, clamped, subdivision)
    }
    
    func subdivide(_ interval: DateInterval, by subdivision: Calendar.Component) -> [DateInterval: Int]? {
      guard let clamped = validInterval.intersection(with: interval) else { return [:] }
      guard !amounts.isEmpty else { return nil }
      
      @Dependency(\.calculator.subdivide) var subdivide
      return subdivide(amounts, clamped, subdivision)
    }
    
    func trend(_ interval: DateInterval, by subdivision: Calendar.Component) -> Double? {
      guard let subdivisions = subdivide(interval, by: subdivision) else { return nil }
      
      @Dependency(\.calculator.trend) var trend
      return trend(Array(subdivisions.values))
    }
    
    func determineTimeSinceLast(for date: Date) -> TimeInterval? {
      guard entries.areLoaded else { return nil }
      
      @Dependency(\.calculator.timeSinceLast) var timeSinceLast
      return timeSinceLast(entries.unwrapped, date)
    }
    
    func determineLongestBreak(until date: Date) -> TimeInterval? {
      guard entries.areLoaded else { return nil }
      
      @Dependency(\.calculator.longestBreak) var longestBreak
      return longestBreak(entries.unwrapped)
    }
    
    func averageTimeBetween(_ interval: DateInterval) -> TimeInterval? {
      guard let clamped = validInterval.intersection(with: interval) else { return 0 }
      guard let amount = amounts[interval] else { return nil }
      
      @Dependency(\.calculator.averageTimeBetween) var averageTimeBetween
      return averageTimeBetween(amount, clamped)
    }
  }
}

extension MainReducer {
  enum Action {
    case entries(Entries.Action)
    
    case calculateAmount(_ interval: DateInterval)
    case calculateAmounts(_ interval: DateInterval, subdivision: Calendar.Component)
    
    case filePorter(FilePorter.Action)
  }
}
