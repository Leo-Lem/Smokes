// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import Foundation

extension StatsView {
  enum ViewAction: Equatable {
    case calculateAverageAmount(selectedInterval: DateInterval)
    case calculateTrendAmount(AverageOption, selectedInterval: DateInterval)

    static func send(_ action: Self) -> MainReducer.Action {
      switch action {
      case let .calculateAverageAmount(selectedInterval):
        return .calculateAmount(selectedInterval)
      case let .calculateTrendAmount(option, selectedInterval):
        return .calculateAmounts(selectedInterval, subdivision: option.comp)
      }
    }
  }
}
