import ComposableArchitecture
import Foundation

struct MainReducer: ReducerProtocol {
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.entries, action: /MainReducer.Action.entries, child: Entries.init)
    Scope(state: \.cache, action: /MainReducer.Action.cache, child: Cache.init)
    Scope(state: \.file, action: /MainReducer.Action.file, child: File.init)
    
    Reduce<State, Action> { state, action in
      switch action {
      case let .entries(.set(entries)):
        return .send(.cache(.reload(entries)))
        
      case let .entries(.add(date)), let .entries(.remove(date)):
        return .send(.cache(.reload(state.entries.entries, date: date)))
        
      case let .load(interval):
        return .send(.cache(.load(state.entries.entries, interval: interval)))
        
      case let .loadAll(interval, subdivision: subdivision):
        return .send(.cache(.loadAll(state.entries.entries, interval: interval, subdivision: subdivision)))
        
      case .file(.create):
        return .send(.file(.setEntries(state.entries.entries)))
        
      case .file(.import):
        return .send(.entries(.set((state.entries.entries + state.file.entries).sorted())))
        
      case let .cache(.reload(entries, _)):
        if state.file.file != nil { return .send(.file(.setEntries(entries))) }
        
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
    case file(File.Action)
    
    case load(_ interval: Interval)
    case loadAll(_ interval: Interval, subdivision: Subdivision)
  }
}
