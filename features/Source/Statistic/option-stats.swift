// Created by Leopold Lemmermann on 24.04.23.

import Components
import Types

public enum StatisticOption: Sendable {
  case perday, perweek, permonth, peryear

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
