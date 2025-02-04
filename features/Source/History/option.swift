// Created by Leopold Lemmermann on 01.04.23.

import protocol Components.ConfigurableWidgetOption
import struct Foundation.Date
import Types

public enum HistoryOption: String, ConfigurableWidgetOption, Sendable {
  case week = "THIS_WEEK", month = "THIS_MONTH", year = "THIS_YEAR"

  func interval(_ date: Date) -> Interval {
    switch self {
    case .week: return .week(date)
    case .month: return .month(date)
    case .year: return .year(date)
    }
  }

  var subdivision: Subdivision {
    switch self {
    case .week: return .day
    case .month: return .week
    case .year: return .month
    }
  }
}
