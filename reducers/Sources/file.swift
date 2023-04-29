// Created by Leopold Lemmermann on 28.04.23.

import Foundation

public struct File: ReducerProtocol {
  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .encode:
      return .run { [encoding = state.encoding, entries = state.entries] send in
        do { await send(.setData(try encoding.encode(entries), encode: false)) } catch { debugPrint(error) }
      }
      .cancellable(id: "decode", cancelInFlight: true)
      
    case .decode:
      return .run { [encoding = state.encoding, data = state.data] send in
        do {
          if let data { await send(.setEntries(try encoding.decode(data), encode: false)) }
        } catch { debugPrint(error) }
      }
      .cancellable(id: "encode", cancelInFlight: true)
      
    case let .setData(data, encode):
      state.data = data
      if encode { return .send(.decode) }
      
    case let .setEncoding(encoding, encode):
      state.encoding = encoding
      if encode { return .send(.encode) }
      
    case let .setEntries(entries, encode):
      state.entries = entries
      if encode { return .send(.encode) }
    }
    
    return .none
  }
}

public extension File {
  struct State: Equatable {
    public internal(set) var data: Data?
    public internal(set) var entries: [Date]
    public internal(set) var encoding: EntriesEncoding
    
    public init(data: Data? = nil, entries: [Date], encoding: EntriesEncoding = .daily) {
      self.data = data
      self.entries = entries
      self.encoding = encoding
    }
  }
}

public extension File {
  enum Action {
    case setData(Data, encode: Bool = true),
         setEntries([Date], encode: Bool = true),
         setEncoding(EntriesEncoding, encode: Bool = true)
    
    case encode,
         decode
  }
}
