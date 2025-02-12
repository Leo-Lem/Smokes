// Created by Leopold Lemmermann on 24.04.23.

import Dependencies
import Types

public enum StatisticOption: String, CaseIterable, Sendable {
  case perday, perweek, permonth, peryear

  public var rawValue: String {
    switch self {
    case .perday: return String(localizable: .perDay)
    case .perweek: return String(localizable: .perWeek)
    case .permonth: return String(localizable: .perMonth)
    case .peryear: return String(localizable: .perYear)
    }
  }

  static func enabledCases(_ interval: Interval) -> [Self] {
    switch interval {
    case .month: return [.perday, .perweek]
    case .year: return [.perday, .perweek, .permonth]
    case .alltime: return [.perday, .perweek, .permonth, .peryear]
    default: return []
    }
  }

  var subdivision: Subdivision {
    switch self {
    case .perday: return .day
    case .perweek: return .week
    case .permonth: return .month
    case .peryear: return .year
    }
  }
}

public enum PlotOption: String, CaseIterable, Sendable {
  case byday, byweek, bymonth, byyear

  public var rawValue: String {
    switch self {
    case .byday: return String(localizable: .byDay)
    case .byweek: return String(localizable: .byWeek)
    case .bymonth: return String(localizable: .byMonth)
    case .byyear: return String(localizable: .byYear)
    }
  }

  static func enabledCases(_ interval: Interval) -> [Self] {
    switch interval {
    case .month: return [.byday, .byweek]
    case .year: return [.byweek, .bymonth]
    case .alltime: return [.bymonth, .byyear]
    default: return []
    }
  }

  var subdivision: Subdivision {
    switch self {
    case .byday: return .day
    case .byweek: return .week
    case .bymonth: return .month
    case .byyear: return .year
    }
  }

  func clamp(_ interval: Interval) -> Interval {
    @Dependency(\.calendar) var cal

    if interval.count(by: .month) ?? 0 > 24, let end = interval.end {
      return .fromTo(.init(start: cal.date(byAdding: .year, value: -2, to: end)!, end: end))
    } else if interval.count(by: .year) ?? 0 > 12, let end = interval.end {
      return .fromTo(.init(start: cal.date(byAdding: .year, value: -12, to: end)!, end: end))
    } else {
      return interval
    }
  }
}
