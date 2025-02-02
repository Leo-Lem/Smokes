// Created by Leopold Lemmermann on 30.04.23.

import Foundation

extension Interval: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    switch (lhs, rhs) {
    case (.day, .day), (.week, .week), (.month, .month), (.year, .year):
      return lhs.start == rhs.start && lhs.end == rhs.end
    case (.alltime, .alltime): return true
    case let (.fromTo(interval1), .fromTo(interval2)): return interval1 == interval2
    case let (.from(date1), .from(date2)), let (.to(date1), .to(date2)): return date1 == date2
    default: return false
    }
  }
}
