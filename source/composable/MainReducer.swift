import ComposableArchitecture
import Foundation

struct MainReducer: ReducerProtocol {
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.entries, action: /MainReducer.Action.entries, child: Entries.init)
    Scope(state: \.filePorter, action: /MainReducer.Action.filePorter, child: FilePorter.init)
    
    Reduce<State, Action> { state, action in
      switch action {
      case let .entries(.updateAmounts(date)):
        let intervals = state.amounts.keys
        return .run { actions in
          if let date {
            for interval in intervals where interval.contains(date) { await actions.send(.calculateAmount(interval)) }
          } else {
            for interval in intervals { await actions.send(.calculateAmount(interval)) }
          }
        }
        
      case let .calculateAmount(interval):
        let entries = state.entries.unwrapped
        state.amounts[interval] = (entries.firstIndex { interval.end < $0 } ?? entries.endIndex) -
          (entries.firstIndex { interval.start <= $0 } ?? entries.endIndex)
        
      case let .calculateAmountUntil(date):
        if let interval = DateInterval(start: state.entries.startDate, safeEnd: date) {
          return .send(.calculateAmount(interval))
        }
        
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

      case let .calculateAmountsUntil(date, subdivision):
        if let interval = DateInterval(start: state.entries.startDate, safeEnd: date) {
          return .send(.calculateAmounts(interval, subdivision: subdivision))
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
    
    var validInterval: DateInterval {
      @Dependency(\.date.now) var now
      @Dependency(\.calendar) var cal
      return DateInterval(start: entries.startDate, end: cal.endOfDay(for: now))
    }
    
    func average(_ interval: DateInterval, by subdivision: Calendar.Component) -> Double? {
      guard let clamped = validInterval.intersection(with: interval) else { return 0 }
      @Dependency(\.calculator.average) var average
      return average(amounts[interval], clamped, subdivision)
    }
    
    func subdivide(_ interval: DateInterval, by subdivision: Calendar.Component) -> [DateInterval: Int]? {
      guard let clamped = validInterval.intersection(with: interval) else { return [:] }
      @Dependency(\.calculator.subdivide) var subdivide
      return subdivide(amounts, clamped, subdivision)
    }
    
    func trend(_ interval: DateInterval, by subdivision: Calendar.Component) -> Double? {
      @Dependency(\.calculator.trend) var trend
      guard let subdivisions = subdivide(interval, by: subdivision) else { return nil }
      return trend(Array(subdivisions.values))
    }
    
    func determineTimeSinceLast(for date: Date) -> TimeInterval? {
      @Dependency(\.calculator.determineTimeSinceLast) var determineTimeSinceLast
      return determineTimeSinceLast(entries.unwrapped, date)
    }
    
    func averageTimeBetween(_ interval: DateInterval) -> TimeInterval? {
      guard let clamped = validInterval.intersection(with: interval) else { return 0 }
      @Dependency(\.calculator.averageTimeBetween) var averageTimeBetween
      return averageTimeBetween(amounts[interval], clamped)
    }
  }
}

extension MainReducer {
  enum Action {
    case entries(Entries.Action)
    
    case calculateAmount(_ interval: DateInterval),
         calculateAmountUntil(_ date: Date),
         calculateAmounts(_ interval: DateInterval, subdivision: Calendar.Component),
         calculateAmountsUntil(_ date: Date, subdivision: Calendar.Component)
    
    case filePorter(FilePorter.Action)
    
    static func prepareAveraging(_ interval: DateInterval) -> Self {
      .calculateAmount(interval)
    }
    
    static func prepareSubdividing(_ interval: DateInterval, by subdivision: Calendar.Component) -> Self {
      .calculateAmounts(interval, subdivision: subdivision)
    }
    
    static func prepareTrending(_ interval: DateInterval, by subdivision: Calendar.Component) -> Self {
      .prepareSubdividing(interval, by: subdivision)
    }
    
    static func prepareAveragingTimeBetween(_ interval: DateInterval) -> Self {
      .calculateAmount(interval)
    }
  }
}
