// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import Foundation

extension StatsView {
  enum ViewAction: Equatable {
    case loadAverage(_ interval: Interval)
    case loadTrend(Subdivision, interval: Interval)

    static func send(_ action: Self) -> MainReducer.Action {
      switch action {
      case let .loadAverage(interval):
        return .load(interval)
      case let .loadTrend(subdivision, interval):
        return .loadAll(interval, subdivision: subdivision)
      }
    }
  }
}
