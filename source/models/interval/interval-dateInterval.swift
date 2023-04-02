// Created by Leopold Lemmermann on 02.04.23.

import Dependencies
import Foundation

extension Interval {
  @Dependency(\.calendar) private static var cal
  
  var dateInterval: DateInterval {
    switch self {
    case let .day(date): return Self.cal.dateInterval(of: .day, for: date)!.removingLastSecond()
    case let .week(date): return Self.cal.dateInterval(of: .weekOfYear, for: date)!.removingLastSecond()
    case let .month(date): return Self.cal.dateInterval(of: .month, for: date)!.removingLastSecond()
    case let .year(date): return Self.cal.dateInterval(of: .year, for: date)!.removingLastSecond()
    case .alltime: return DateInterval(start: .distantPast, end: .distantFuture)
    case let .fromTo(interval): return interval
    case let .from(date): return DateInterval(start: date, end: .distantFuture)
    case let .to(date): return DateInterval(start: .distantPast, end: date)
    }
  }
}

fileprivate extension DateInterval {
  func removingLastSecond() -> Self { Self(start: start, end: end - 1) }
}
