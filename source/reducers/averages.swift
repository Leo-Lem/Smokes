// Created by Leopold Lemmermann on 03.03.23.

import ComposableArchitecture
import Foundation

struct Averages: ReducerProtocol {
  struct State: Equatable {
    var cache = [Calendar.Component: [DateInterval: Double]]()
    
    subscript(_ interval: DateInterval, by component: Calendar.Component) -> Double? {
      get { cache[component]?[interval] }
      set { cache[component]?[interval] = newValue }
    }
  }
  
  enum Action {
    case calculate(_ interval: DateInterval, _ component: Calendar.Component, _ amount: Int)
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .calculate(interval, component, amount):
      @Dependency(\.calendar) var cal: Calendar
      let length = cal.dateComponents([component], from: interval.start, to: interval.end).value(for: component) ?? 1
      state.cache[component] = [interval: Double(amount) / Double(length == 0 ? 1 : length)]
    }
    
    return .none
  }
}
