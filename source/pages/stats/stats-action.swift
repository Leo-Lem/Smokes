// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import Foundation

extension StatsView {
  enum ViewAction: Equatable {
    case calculateAverage(Interval, Subdivision)
    
    case calculateTrend(Interval, Subdivision)

    static func send(_ action: Self) -> MainReducer.Action {
      switch action {
      case let .calculateAverage(interval, subdivision): return .calculateAverage(interval, subdivision)
        
      case let .calculateTrend(interval, subdivision): return .calculateTrend(interval, subdivision)
      }
    }
  }
}
