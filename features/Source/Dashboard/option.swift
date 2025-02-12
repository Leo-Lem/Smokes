// Created by Leopold Lemmermann on 01.04.23.

import SwiftUI
import struct Dependencies.Dependency
import enum Types.Interval

public enum AmountOption: String, CaseIterable, Sendable {
  case yesterday, week, month, year

  public var rawValue: String {
    switch self {
    case .yesterday: String(localizable: .yesterday)
    case .week: String(localizable: .week)
    case .month: String(localizable: .month)
    case .year: String(localizable: .year)
    }
  }

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

public enum TimeOption: String, CaseIterable, Sendable {
  case sinceLast, longestBreak

  public var rawValue: String {
    switch self {
    case .sinceLast: String(localizable: .sinceLast)
    case .longestBreak: String(localizable: .longestBreak)
    }
  }
}
