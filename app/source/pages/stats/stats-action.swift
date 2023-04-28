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
      case let .calculateAverage(interval, subdivision): return .calculator(.average(interval, subdivision))
      case let .calculateTrend(interval, subdivision): return .calculator(.trend(interval, subdivision))
      case let.calculateAverageBreak(interval): return .calculator(.averageBreak(interval))
      }
    }
    
    static func update(_ vs: ViewStore<ViewState, ViewAction>, selection: Interval) {
      Option.enabledCases(selection).forEach {
        vs.send(.calculateAverage(selection, $0.subdivision))
        vs.send(.calculateTrend(selection, $0.subdivision))
        vs.send(.calculateAverageBreak(selection))
      }
    }
  }
}
