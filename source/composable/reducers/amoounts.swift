// Created by Leopold Lemmermann on 02.04.

import ComposableArchitecture
import Foundation

struct Cache: ReducerProtocol {
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .load(entries, interval):
      state.amounts[interval] = amount(entries, interval)

    case let .loadAll(entries, interval, subdivision):
      return .run { actions in
        for subInterval in interval.enumerate(by: subdivision) {
          await actions.send(.load(entries, interval: subInterval))
        }
      }
    
    case let .reload(entries, date):
      let intervals = state.amounts.map(\.key)
      return .run { actions in
        if let date {
          for interval in intervals where interval.contains(date) {
            await actions.send(.load(entries, interval: interval))
          }
        } else {
          for interval in intervals {
            await actions.send(.load(entries, interval: interval))
          }
        }
      }
    }

    return .none
  }
  
  @Dependency(\.calculator.amount) private var amount
}

extension Cache {
  enum Action {
    case load(_ entries: [Date], interval: Interval)
    case loadAll(_ entries: [Date], interval: Interval, subdivision: Subdivision)
    case reload(_ entries: [Date], date: Date? = nil)
  }
}

extension Cache {
  struct State: Equatable {
    var amounts = [Interval: Int]()
    
    var isEmpty: Bool { amounts.isEmpty }

    subscript (_ interval: Interval) -> Int? { amounts[interval] }
    
    func relevantIntervals(for date: Date?) -> [Interval] {
      if let date { return amounts.map(\.key).filter { $0.contains(date) } } else { return amounts.map(\.key) }
    }
  }
}
