// Created by Leopold Lemmermann on 28.04.23.

import ComposableArchitecture

public struct App: Reducer {
  public var body: some Reducer<State, Action> {
    Scope(state: \.entries, action: \.entries, child: Entries.init)

    Reduce { state, action in
      return switch action {
      case .loadEntries:
          .run { send in
            do {
              if let loaded = try await persist.read() { await send(.entries(.set(loaded))) }
            } catch { debugPrint(error) }
            await send(.entries(.set([])))
          }
          .cancellable(id: "load", cancelInFlight: true)

      case .saveEntries:
          .run { [entries = state.entries] _ in
            do { try await persist.write(entries.array) } catch { debugPrint(error) }
          }
          .cancellable(id: "save", cancelInFlight: true)
      default: .none
      }
    }
  }
  
  @Dependency(\.persist) private var persist
  
  public init() {}
}

public extension App {
  @ObservableState
  struct State: Equatable {
    public internal(set) var entries: Entries.State
    
    public init(_ entries: Entries.State = Entries.State([])) { self.entries = entries }
  }
}

public extension App {
  @CasePathable
  enum Action {
    case loadEntries,
         saveEntries
    
    case entries(Entries.Action)
  }
}
