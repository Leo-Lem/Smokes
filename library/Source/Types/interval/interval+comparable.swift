// Created by Leopold Lemmermann on 30.04.23.

import Foundation

extension Interval: Comparable {
  public static func < (lhs: Interval, rhs: Interval) -> Bool {
    switch (lhs, rhs) {
    case (.day, .day), (.week, .week), (.month, .month), (.year, .year): return lhs.start! < rhs.start!
    case let (.fromTo(interval1), .fromTo(interval2)): return interval1 < interval2
    default: return false
    }
  }
}
