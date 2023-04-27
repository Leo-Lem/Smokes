import ComposableArchitecture
import Foundation

struct MainReducer: ReducerProtocol {
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.entries, action: /Action.entries, child: Entries.init)
    Scope(state: \.file, action: /Action.file, child: File.init)
    Scope(state: \.calculate, action: /Action.calculate, child: Calculate.init)
    
    Reduce<State, Action> { state, action in
      switch action {
      case .createFile:
        return .run { [entries = state.entries.entries] send in
          await send(.file(.set(nil)))
          await send(.file(.setEntries(entries)))
          await send(.file(.create))
        }
        
      case .file(.import):
        if state.file.importError == nil {
          return .send(.entries(.set((state.entries.entries + state.file.entries).sorted())))
        }
        
      case let .calculateFilter(interval): return .send(.calculate(.filter(clamp(interval))))
      case let .calculateAmount(interval): return .send(.calculate(.amount(clamp(interval))))
      case let .calculateAverage(interval, sub): return .send(.calculate(.average(clamp(interval), sub)))
      case let .calculateTrend(interval, sub): return .send(.calculate(.trend(clamp(interval), sub)))
      case let .calculateBreak(date): return .send(.calculate(.break(date)))
      case let .calculateLongestBreak(date): return .send(.calculate(.longestBreak(date)))
      case let .calculateAverageBreak(interval): return .send(.calculate(.averageBreak(clamp(interval))))
        
      // keep data in sync
      case let .entries(.set(entries)):
        return .run { send in
          await send(.calculate(.updateEntries(entries)))
          await send(.file(.setEntries(entries)))
        }
        
      default:
        break
      }
      return .none
      
      func clamp(_ interval: Interval) -> Interval {
        @Dependency(\.calendar) var cal
        @Dependency(\.date.now) var now
        
        var start = cal.startOfDay(for: state.entries.startDate), end = cal.endOfDay(for: now)
        
        switch interval {
        case .alltime: break
        case let .from(date): start = min(end, date)
        case let .to(date): end = max(start, date)
        default: return interval
        }
        
        return .fromTo(.init(start: start, end: end))
      }
    }
  }
}

extension MainReducer {
  struct State: Equatable {
    var entries = Entries.State()
    var file = File.State()
    fileprivate var calculate = Calculate.State()
    
    func entries(for interval: Interval) -> [Date]? {
      calculate.filtereds[clamp(interval)]
    }
    
    func amount(for interval: Interval) -> Int? {
      calculate.amounts[clamp(interval)]
    }
    
    func average(for interval: Interval, by sub: Subdivision) -> Double? {
      calculate.averages[.init(clamp(interval), sub)]
    }
    
    func trend(for interval: Interval, by sub: Subdivision) -> Double? {
      calculate.trends[.init(clamp(interval), sub)]
    }
    
    func `break`(for date: Date) -> TimeInterval? {
      calculate.breaks[date]
    }
    
    func longestBreak(until date: Date) -> TimeInterval? {
      calculate.longestBreaks[date]
    }
    
    func averageBreak(_ interval: Interval) -> TimeInterval? {
      calculate.averageBreaks[clamp(interval)]
    }
    
    private func clamp(_ interval: Interval) -> Interval {
      @Dependency(\.calendar) var cal
      @Dependency(\.date.now) var now
      
      var start = cal.startOfDay(for: entries.startDate), end = cal.endOfDay(for: now)
      
      switch interval {
      case .alltime: break
      case let .from(date): start = min(end, date)
      case let .to(date): end = max(start, date)
      default: return interval
      }
      
      return .fromTo(.init(start: start, end: end))
    }
  }
}

extension MainReducer {
  enum Action {
    case entries(Entries.Action)
    
    case file(File.Action),
         createFile
    
    case calculate(Calculate.Action),
         calculateFilter(Interval),
         calculateAmount(Interval),
         calculateAverage(Interval, Subdivision),
         calculateTrend(Interval, Subdivision),
         calculateBreak(Date),
         calculateLongestBreak(Date),
         calculateAverageBreak(Interval)
  }
}
