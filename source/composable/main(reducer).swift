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
    }
  }
}

extension MainReducer {
  struct State: Equatable {
    var entries = Entries.State()
    var file = File.State()
    fileprivate var calculate = Calculate.State()
    
    func entries(for interval: Interval) -> [Date]? { calculate.filtereds[interval] }
    
    func amount(for interval: Interval) -> Int? {
      calculate.amounts[mapAlltimeInterval(interval)]
    }
    
    func average(for interval: Interval, by sub: Subdivision) -> Double? {
      calculate.averages[.init(mapAlltimeInterval(interval), sub)]
    }
    
    func trend(for interval: Interval, by sub: Subdivision) -> Double? {
      calculate.trends[.init(mapAlltimeInterval(interval), sub)]
    }
    
    func `break`(for date: Date) -> TimeInterval? {
      calculate.breaks[date]
    }
    
    func longestBreak(until date: Date) -> TimeInterval? {
      calculate.longestBreaks[date]
    }
    
    func averageBreak(_ interval: Interval) -> TimeInterval? {
      calculate.averageBreaks[mapAlltimeInterval(interval)]
    }
    
    private func mapAlltimeInterval(_ interval: Interval) -> Interval {
      @Dependency(\.calendar) var cal
      @Dependency(\.date.now) var now
      return interval == .alltime
        ? .fromTo(.init(start: cal.startOfDay(for: entries.startDate), end: cal.endOfDay(for: now)))
        : interval
    }
  }
}

extension MainReducer {
  enum Action {
    case entries(Entries.Action)
    
    case file(File.Action),
         createFile
    
    case calculate(Calculate.Action)
  }
}
