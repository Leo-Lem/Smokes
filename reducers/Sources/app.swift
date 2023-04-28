// Created by Leopold Lemmermann on 28.04.23.

public struct App: ReducerProtocol {
  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .loadEntries:
        return .task {
          do {
            if let loaded = try await persistor.readDates() { return .setEntries(.init(loaded)) }
          } catch { debugPrint(error) }
          
          return .setEntries([])
        }
        
      case .saveEntries:
        return .fireAndForget { [entries = state.entries] in
          do {
            if let entries { try await persistor.writeDates(entries.array) }
          } catch { debugPrint(error) }
        }
        
      case let .setEntries(entries):
        if state.entries == nil {
          state.entries = entries
          state.calculator = Calculator.State(entries)
          state.file = File.State(entries: entries)
        } else {
          return .merge(
            .send(.calculator(.setEntries(entries))),
            .send(.file(.setEntries(entries)))
          )
        }
        
      default: break
      }
      
      return .none
    }
    .ifLet(\.entries, action: /Action.entries, then: Entries.init)
    .ifLet(\.calculator, action: /Action.calculator, then: Calculator.init)
  }
  
  @Dependency(\.persistor) private var persistor
  
  public init() {}
}

public extension App {
  struct State: Equatable {
    public internal(set) var entries: Entries.State?
    public internal(set) var calculator: Calculator.State?
    public internal(set) var file: File.State?
    
    public init(entries: Entries.State? = nil, calculator: Calculator.State? = nil, file: File.State? = nil) {
      self.entries = entries
      self.calculator = calculator
      self.file = file
    }
  }
}

public extension App {
  enum Action {
    case loadEntries,
         saveEntries
    
    case setEntries(Entries.State)
    
    case entries(Entries.Action),
         calculator(Calculator.Action),
         file(File.Action)
  }
}
