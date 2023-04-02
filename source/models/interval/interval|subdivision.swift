// Created by Leopold Lemmermann on 02.04.23.

import Dependencies
import Foundation

extension Interval {
  @Dependency(\.calendar) private static var cal
  
  init(_ subdivision: Subdivision, date: Date) {
    switch subdivision {
    case .day: self = .day(date)
    case .week: self = .week(date)
    case .month: self = .month(date)
    case .year: self = .year(date)
    }
  }
  
  var subdivision: Subdivision? {
    switch self {
    case .day: return .day
    case .week: return .week
    case .month: return .month
    case .year: return .year
    default: return nil
    }
  }
  
  func count(by subdivision: Subdivision, onlyComplete: Bool = false) -> Int? {
    guard let start, let end else { return nil }
    
    if onlyComplete {
      return Self.cal.dateComponents([subdivision.comp], from: start, to: end).value(for: subdivision.comp)
    } else {
      var count = 0, date = start
      
      while date < end {
        count += 1
        date = Self.cal.date(byAdding: subdivision.comp, value: 1, to: date)!
      }
      
      return count
    }
  }

  func enumerate(by subdivision: Subdivision, in bounds: Interval? = nil) -> [Interval]? {
    guard let start, let end else { return nil }
    
    var intervals = [Interval](), date = max(start, bounds?.start ?? start)
    
    while date < min(end, bounds?.end ?? end) {
      intervals.append(Interval(subdivision, date: date))
      date = Self.cal.date(byAdding: subdivision.comp, value: 1, to: date)!
    }
    
    return intervals
  }
}
