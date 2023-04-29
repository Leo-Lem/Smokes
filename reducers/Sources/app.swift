// Created by Leopold Lemmermann on 28.04.23.

import ComposableArchitecture

public struct App: ReducerProtocol {
  public var body: some ReducerProtocol<State, Action> {
    Scope(state: \.entries, action: /Action.entries, child: Entries.init)
    Scope(state: \.calculate, action: /Action.calculate, child: Calculate.init)
    Scope(state: \.file, action: /Action.file, child: File.init)
    
    Reduce { state, action in
      switch action {
      case .loadEntries:
        return .task {
          do {
            if let loaded = try await persistor.readDates() { return .entries(.set(loaded)) }
          } catch { debugPrint(error) }
          
          return .entries(.set([]))
        }
        .cancellable(id: "load", cancelInFlight: true)
        
      case .saveEntries:
        return .fireAndForget { [entries = state.entries] in
          do { try await persistor.writeDates(entries.array) } catch { debugPrint(error) }
        }
        .cancellable(id: "save", cancelInFlight: true)
        
      case .entries(.change):
        return .merge(
          .send(.calculate(.setEntries(state.entries))),
          .send(.file(.setEntries(state.entries.array)))
        )
        
      default: break
      }
      
      return .none
    }
  }
  
  @Dependency(\.persistor) private var persistor
  
  public init() {}
}

public extension App {
  struct State: Equatable {
    public internal(set) var entries: Entries.State
    public internal(set) var calculate: Calculate.State
    public internal(set) var file: File.State
    
    internal init(entries: Entries.State, calculate: Calculate.State, file: File.State) {
      self.entries = entries
      self.calculate = calculate
      self.file = file
    }
    
    public init(_ entries: Entries.State = Entries.State([])) {
      self.init(entries: entries, calculate: .init(entries), file: .init(entries: entries.array))
    }
  }
}

public extension App {
  enum Action {
    case loadEntries,
         saveEntries
    
    case entries(Entries.Action),
         calculate(Calculate.Action),
         file(File.Action)
  }
}
