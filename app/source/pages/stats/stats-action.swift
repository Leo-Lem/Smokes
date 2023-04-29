// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import SwiftUI

extension StatsView {
  enum ViewAction: Equatable {
    case calculateAverage(Interval, Subdivision)
    case calculateTrend(Interval, Subdivision)
    case calculateAverageBreak(Interval)

    static func send(_ action: Self) -> App.Action {
      switch action {
      case let .calculateAverage(interval, subdivision): return .calculate(.average(interval, subdivision))
      case let .calculateTrend(interval, subdivision): return .calculate(.trend(interval, subdivision))
      case let.calculateAverageBreak(interval): return .calculate(.averageBreak(interval))
      }
    }
    
    static func update(_ vs: ViewStore<ViewState, ViewAction>, selection: Interval, option: Option) {
      vs.send(.calculateAverage(selection, option.subdivision))
      vs.send(.calculateTrend(selection, option.subdivision))
      vs.send(.calculateAverageBreak(selection))
    }
  }
}
