// Created by Leopold Lemmermann on 28.04.23.

import Foundation

public struct File: ReducerProtocol {
  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .encode:
      do {
        state.data = nil
        state.data = try state.encoding.encode(state.entries.array)
      } catch { debugPrint(error) }
      
    case .decode:
      do {
        if let data = state.data { state.entries = .init(try state.encoding.decode(data)) }
      } catch { debugPrint(error) }
      
    case let .setData(data):
      state.data = data
      return .send(.decode)
      
    case let .setEncoding(encoding):
      state.encoding = encoding
      return .send(.encode)
      
    case let .setEntries(entries):
      state.entries = entries
      return .send(.encode)
    }
    
    return .none
  }
}

public extension File {
  struct State: Equatable {
    public internal(set) var data: Data?
    public internal(set) var entries: Entries.State
    public internal(set) var encoding: EntriesEncoding
    
    public init(
      data: Data? = nil,
      entries: Entries.State,
      encoding: EntriesEncoding = .daily
    ) {
      self.data = data
      self.entries = entries
      self.encoding = encoding
    }
  }
}

public extension File {
  enum Action {
    case setData(Data),
         setEntries(Entries.State),
         setEncoding(EntriesEncoding)
    
    case encode,
         decode
  }
}
