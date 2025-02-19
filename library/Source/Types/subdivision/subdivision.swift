// Created by Leopold Lemmermann on 02.04.23.

import Foundation

public enum Subdivision: Hashable, CaseIterable, Codable, Sendable {
  case day, week, month, year

  var comp: Calendar.Component {
    switch self {
    case .day: return .day
    case .week: return .weekOfYear
    case .month: return .month
    case .year: return .year
    }
  }

  init?(_ comp: Calendar.Component) {
    switch comp {
    case .day: self = .day
    case .weekOfYear: self = .week
    case .month: self = .month
    case .year: self = .year
    default: return nil
    }
  }

  init?(_ interval: Interval) {
    switch interval {
    case .day: self = .day
    case .week: self = .week
    case .month: self = .month
    case .year: self = .year
    default: return nil
    }
  }

  func interval(_ date: Date) -> Interval {
    switch self {
    case .day: return .day(date)
    case .week: return.week(date)
    case .month: return .month(date)
    case .year: return .year(date)
    }
  }
}
