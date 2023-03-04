// Created by Leopold Lemmermann on 03.03.23.

import ComposableArchitecture
import Foundation

struct Amounts: ReducerProtocol {
  struct State: Equatable {
    var cache = [DateInterval: Int]()
    
    subscript(_ interval: DateInterval) -> Int? {
      get { cache[interval] }
      set { cache[interval] = newValue }
    }
  }
  
  enum Action {
    case calculate(_ interval: DateInterval, _ entries: [Date])
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .calculate(interval, entries):
      state.cache[interval] = (entries.firstIndex { interval.end < $0 } ?? entries.endIndex) -
        (entries.firstIndex { interval.start <= $0 } ?? entries.endIndex)
    }
    
    return .none
  }
}
