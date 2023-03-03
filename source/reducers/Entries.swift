// Created by Leopold Lemmermann on 03.03.23.

import ComposableArchitecture
import Foundation

struct Entries: ReducerProtocol {
  struct State: Equatable {
    var dates: [Date]
    var startDate: Date { dates.min() ?? Dependency(\.date.now).wrappedValue }
  }
  
  enum Action {
    case add(Date), remove(Date)
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .add(date):
      state.dates.insert(date, at: state.dates.firstIndex { date < $0 } ?? state.dates.endIndex)
      
    case let .remove(date):
      if let index = state.dates.firstIndex(where: { $0 <= date }) { state.dates.remove(at: index) }
    }
    
    return .none
  }
}
