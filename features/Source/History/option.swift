// Created by Leopold Lemmermann on 01.04.23.

import struct Foundation.Date
import Types

public enum HistoryOption: String, CaseIterable, Sendable {
  case week, month, year

  public var rawValue: String {
    switch self {
    case .week: String(localizable: .week)
    case .month: String(localizable: .month)
    case .year: String(localizable: .year)
    }
  }

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
