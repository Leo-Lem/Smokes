import ComposableArchitecture
import Foundation

struct MainReducer: ReducerProtocol {
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.entries, action: /MainReducer.Action.entries, child: Entries.init)
    Scope(state: \.cache, action: /MainReducer.Action.cache, child: Cache.init)
    Scope(state: \.filePorter, action: /MainReducer.Action.filePorter, child: File.init)
    
    Reduce<State, Action> { state, action in
      switch action {
      case let .entries(.set(entries)):
        return .send(.cache(.reload(entries)))
        
      case let .entries(.add(date)), let .entries(.remove(date)):
        return .send(.cache(.reload(state.entries.entries, date: date)))
        
      case let .load(interval):
        return .send(.cache(.load(state.entries.entries, interval: interval)))
        
      case let .loadAll(interval, subdivision: subdivision):
        return .send(.cache(.loadAll(
          state.entries.entries, interval: interval, subdivision: subdivision
        )))
        
      case let .filePorter(.addEntries(entries)):
        return .send(.entries(.set((state.entries.entries + entries).sorted())))
        
      default:
        break
      }
      return .none
    }
  }
}

extension MainReducer {
  enum Action {
    case entries(Entries.Action)
    case cache(Cache.Action)
    case filePorter(File.Action)
    
    case load(_ interval: Interval)
    case loadAll(_ interval: Interval, subdivision: Subdivision)
  }
}
