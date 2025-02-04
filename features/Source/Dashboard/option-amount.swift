// Created by Leopold Lemmermann on 01.04.23.

import Components
import struct Dependencies.Dependency
import enum Types.Interval

public enum AmountOption: String, ConfigurableWidgetOption, Sendable {
  case yesterday = "YESTERDAY",
       week = "THIS_WEEK",
       month = "THIS_MONTH",
       year = "THIS_YEAR"

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
