// Created by Leopold Lemmermann on 24.04.23.

import Components
import Dependencies
import Types

public enum PlotOption: Sendable {
  case byday, byweek, bymonth, byyear

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
