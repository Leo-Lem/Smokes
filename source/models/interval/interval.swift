// Created by Leopold Lemmermann on 02.04.23.

import Dependencies
import Foundation

enum Interval {
  case day(Date), week(Date), month(Date), year(Date)
  case alltime, from(Date), to(Date), fromTo(DateInterval)
}

extension Interval {
  var start: Date? {
    @Dependency(\.calendar) var cal
    
    switch self {
    case .alltime, .to: return nil
    case let .from(date): return date
    case let .fromTo(interval): return interval.start
    case let .day(date), let .week(date), let .month(date), let .year(date):
      return cal.start(of: subdivision!.comp, for: date)
    }
  }
  
  var end: Date? {
    @Dependency(\.calendar) var cal
    
    switch self {
    case .alltime, .from: return nil
    case let .to(date): return date
    case let .fromTo(interval): return interval.end
    case let .day(date), let .week(date), let .month(date), let .year(date):
      return cal.end(of: subdivision!.comp, for: date)
    }
  }
  
  var duration: TimeInterval {
    switch self {
    case .alltime, .from, .to: return .infinity
    case .day, .week, .month, .year: return start!.distance(to: end!)
    case let .fromTo(interval): return interval.duration
    }
  }
  
  func contains(_ date: Date) -> Bool {
    if let start, start > date { return false }
    if let end, end < date { return false }
    return true
  }
}

extension Interval {
  func next(in bounds: Interval? = nil) -> Self? {
    @Dependency(\.calendar) var cal
    
    if let end, let bound = bounds?.end, bound <= end { return nil }
    
    switch self {
    case let .day(date): return .day(cal.date(byAdding: .day, value: 1, to: date)!)
    case let .week(date): return .week(cal.date(byAdding: .weekOfYear, value: 1, to: date)!)
    case let .month(date): return .month(cal.date(byAdding: .month, value: 1, to: date)!)
    case let .year(date): return .year(cal.date(byAdding: .year, value: 1, to: date)!)
    default: return nil
    }
  }
  
  func previous(in bounds: Interval? = nil) -> Self? {
    @Dependency(\.calendar) var cal
    
    if let start, let bound = bounds?.start, start <= bound { return nil }
    
    switch self {
    case let .day(date): return .day(cal.date(byAdding: .day, value: -1, to: date)!)
    case let .week(date): return .week(cal.date(byAdding: .weekOfYear, value: -1, to: date)!)
    case let .month(date): return .month(cal.date(byAdding: .month, value: -1, to: date)!)
    case let .year(date): return .year(cal.date(byAdding: .year, value: -1, to: date)!)
    default: return nil
    }
  }
}

extension Interval: Codable {}
