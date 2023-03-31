// Created by Leopold Lemmermann on 01.04.23.

import Dependencies
import Foundation

extension HistoryView {
  enum ViewAction: Equatable {
    case add, remove
    case calculateDayAmount(Date? = nil)
    case calculateUntilHereAmount(Date? = nil)
    case calculateOptionAmount(IntervalOption, Date? = nil)

    static func send(_ action: Self, selectedDate: Date) -> MainReducer.Action {
      @Dependency(\.calendar) var cal
      
      switch action {
      case .add:
        return .entries(.add(selectedDate))
      case .remove:
        return .entries(.remove(selectedDate))
      case let .calculateDayAmount(date):
        return .calculateAmount(.day(of: date ?? selectedDate))
      case let .calculateUntilHereAmount(date):
        return .calculateAmount(.untilEndOfDay(of: date ?? selectedDate))
      case let .calculateOptionAmount(option, date):
        return .calculateAmount(option.interval(date ?? selectedDate))
      }
    }
  }
}
