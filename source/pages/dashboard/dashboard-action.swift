// Created by Leopold Lemmermann on 01.04.23.

import Dependencies
import Foundation

extension DashboardView {
  enum ViewAction {
    case add, remove
    case calculateDay
    case calculateUntilHere
    case calculateOption(IntervalOption)
    
    static func send(_ action: Self) -> MainReducer.Action {
      @Dependency(\.date.now) var now: Date
      
      switch action {
      case .add: return .entries(.add(now))
      case .remove: return .entries(.remove(now))
      case .calculateDay: return .calculateAmount(.day)
      case let .calculateOption(option): return .calculateAmount(option.interval)
      case .calculateUntilHere: return .calculateAmount(.untilEndOfDay)
      }
    }
  }
}
