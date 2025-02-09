// Created by Leopold Lemmermann on 01.04.23.

import Components
import struct Dependencies.Dependency
import enum Types.Interval

// TODO: move to L10n
public enum AmountOption: String, ConfigurableWidgetOption, Sendable {
  case yesterday = "amount.yesterday",
       week = "amount.week",
       month = "amount.month",
       year = "amount.year"

  var interval: Interval {
    @Dependency(\.calendar) var cal
    @Dependency(\.date.now) var now

    switch self {
    case .yesterday: return .day(cal.startOfDay(for: now) - 1)
    case .week: return .week(now)
    case .month: return .month(now)
    case .year: return .year(now)
    }
  }
}
