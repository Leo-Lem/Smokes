// Created by Leopold Lemmermann on 28.04.23.

import ComposableArchitecture

public struct App: ReducerProtocol {
  public var body: some ReducerProtocol<State, Action> {
    Scope(state: \.entries, action: /Action.entries, child: Entries.init)
    Scope(state: \.calculator, action: /Action.calculator, child: Calculator.init)
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
        
      case .saveEntries:
        return .fireAndForget { [entries = state.entries] in
          do { try await persistor.writeDates(entries.array) } catch { debugPrint(error) }
        }
        
      case .entries(.change):
        return .merge(
          .send(.calculator(.setEntries(state.entries))),
          .send(.file(.setEntries(state.entries)))
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
    public internal(set) var calculator: Calculator.State
    public internal(set) var file: File.State
    
    public init(entries: Entries.State, calculator: Calculator.State, file: File.State) {
      self.entries = entries
      self.calculator = calculator
      self.file = file
    }
    
    public init(_ entries: Entries.State = Entries.State([])) {
      self.init(entries: entries, calculator: .init(entries), file: .init(entries: entries))
    }
  }
}

public extension App {
  enum Action {
    case loadEntries,
         saveEntries
    
    case entries(Entries.Action),
         calculator(Calculator.Action),
         file(File.Action)
  }
}
