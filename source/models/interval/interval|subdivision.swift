// Created by Leopold Lemmermann on 02.04.23.

import Dependencies
import Foundation

extension Interval {
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
  
  func count(by subdivision: Subdivision) -> Int? {
    @Dependency(\.calendar) var cal
    
    guard let start, let end else { return nil }
    
    return cal.dateComponents([subdivision.comp], from: start, to: end).value(for: subdivision.comp)
  }

  func enumerate(by subdivision: Subdivision, in bounds: Interval? = nil) -> [Interval]? {
    @Dependency(\.calendar) var cal
    
    guard var start, var end else { return nil }
    start = max(start, bounds?.start ?? start)
    end = min(end, bounds?.end ?? end)
    
    var intervals = [Interval](), date = start
    
    while date < end {
      intervals.append(Interval(subdivision, date: date))
      date = cal.date(byAdding: subdivision.comp, value: 1, to: date)!
    }
    
    if cal.isDate(date, equalTo: end, toGranularity: subdivision.comp) {
      intervals.append(Interval(subdivision, date: date))
    }
    
    return intervals
  }
}
