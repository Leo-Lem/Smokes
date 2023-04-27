// Created by Leopold Lemmermann on 02.04.

import ComposableArchitecture

struct Cache<Key: Hashable, Value: Equatable>: ReducerProtocol {
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .insert(key, value): state.keyedValues[key] = value
    }
    
    return .none
  }
  
  struct State: Equatable {
    var keyedValues = [Key: Value]()
  }

  enum Action {
    case insert(Key, Value)
  }
}
