// Created by Leopold Lemmermann on 02.04.23.

import Dependencies
import Foundation

enum Interval {
  case day(Date), week(Date), month(Date), year(Date)
  case alltime, from(Date), to(Date), fromTo(DateInterval)
}

extension Interval {
  @Dependency(\.calendar) private static var cal

  func contains(_ date: Date) -> Bool { dateInterval.contains(date) }

  func next(in bounds: Interval? = nil) -> Self? {
    if let end, let bound = bounds?.end, bound <= end { return nil }
    
    switch self {
    case let .day(date): return .day(Self.cal.date(byAdding: .day, value: 1, to: date)!)
    case let .week(date): return .week(Self.cal.date(byAdding: .weekOfYear, value: 1, to: date)!)
    case let .month(date): return .month(Self.cal.date(byAdding: .month, value: 1, to: date)!)
    case let .year(date): return .year(Self.cal.date(byAdding: .year, value: 1, to: date)!)
    default: return nil
    }
  }
  
  func previous(in bounds: Interval? = nil) -> Self? {
    if let start, let bound = bounds?.start, start <= bound { return nil }
    
    switch self {
    case let .day(date): return .day(Self.cal.date(byAdding: .day, value: -1, to: date)!)
    case let .week(date): return .week(Self.cal.date(byAdding: .weekOfYear, value: -1, to: date)!)
    case let .month(date): return .month(Self.cal.date(byAdding: .month, value: -1, to: date)!)
    case let .year(date): return .year(Self.cal.date(byAdding: .year, value: -1, to: date)!)
    default: return nil
    }
  }
  
  var start: Date? {
    switch self {
    case .day, .week, .month, .year, .from, .fromTo: return dateInterval.start
    default: return nil
    }
  }
  
  var end: Date? {
    switch self {
    case .day, .week, .month, .year, .to, .fromTo: return dateInterval.end
    default: return nil
    }
  }
}
