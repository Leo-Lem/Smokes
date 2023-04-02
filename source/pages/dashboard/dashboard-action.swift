// Created by Leopold Lemmermann on 01.04.23.

import Dependencies
import Foundation

extension DashboardView {
  enum ViewAction {
    case add, remove
    case loadDay
    case loadUntilNow
    case loadOption(AmountOption)
    
    static func send(_ action: Self) -> MainReducer.Action {
      @Dependency(\.date.now) var now: Date
      
      switch action {
      case .add: return .entries(.add(now))
      case .remove: return .entries(.remove(now))
      case .loadDay: return .load(.day(now))
      case let .loadOption(option): return .load(option.interval)
      case .loadUntilNow: return .load(.to(.endOfToday))
      }
    }
  }
}
