// Created by Leopold Lemmermann on 28.04.23.

import ComposableArchitecture

public struct App: ReducerProtocol {
  public var body: some ReducerProtocol<State, Action> {
    Scope(state: \.entries, action: /Action.entries, child: Entries.init)
    Scope(state: \.file, action: /Action.file, child: File.init)
    
    Reduce { state, action in
      switch action {
      case .loadEntries:
        return .task {
          do {
            if let loaded = try await persist.read() { return .entries(.set(loaded)) }
          } catch { debugPrint(error) }
          
          return .entries(.set([]))
        }
        .cancellable(id: "load", cancelInFlight: true)
        
      case .saveEntries:
        return .fireAndForget { [entries = state.entries] in
          do { try await persist.write(entries.array) } catch { debugPrint(error) }
        }
        .cancellable(id: "save", cancelInFlight: true)
        
      case .entries(.change):
        return .send(.file(.setEntries(state.entries.array)))
        
      default: break
      }
      
      return .none
    }
  }
  
  @Dependency(\.persist) private var persist
  
  public init() {}
}

public extension App {
  struct State: Equatable {
    public internal(set) var entries: Entries.State
    public internal(set) var file: File.State
    
    internal init(entries: Entries.State, file: File.State) {
      self.entries = entries
      self.file = file
    }
    
    public init(_ entries: Entries.State = Entries.State([])) {
      self.init(entries: entries, file: .init(entries: entries.array))
    }
  }
}

public extension App {
  enum Action {
    case loadEntries,
         saveEntries
    
    case entries(Entries.Action),
         file(File.Action)
  }
}
