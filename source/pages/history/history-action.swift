// Created by Leopold Lemmermann on 01.04.23.

import Dependencies
import Foundation

extension HistoryView {
  enum ViewAction: Equatable {
    case add, remove
    case loadDay(_ date: Date? = nil)
    case loadUntilHere(_ date: Date? = nil)
    case loadOption(IntervalOption, date: Date? = nil)

    static func send(_ action: Self, selectedDate: Date) -> MainReducer.Action {
      @Dependency(\.calendar) var cal
      
      switch action {
      case .add:
        return .entries(.add(selectedDate))
      case .remove:
        return .entries(.remove(selectedDate))
      case let .loadDay(date):
        return .calculate(.amount(.day(date ?? selectedDate)))
      case let .loadUntilHere(date):
        return .calculate(.amount(.to(date ?? selectedDate)))
      case let .loadOption(option, date):
        return .calculate(.amount(option.interval(date ?? selectedDate)))
      }
    }
  }
}
