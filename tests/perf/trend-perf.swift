// Created by Leopold Lemmermann on 28.02.23.

import XCTest

final class TrendPerformanceTests: XCTestCase {
  func testPerformance() {
    measure {
      _ = trend(for: .example, by: .day)
    }
  }
  
  private func trend(for interval: DateInterval, by component: Calendar.Component) -> Double {
    let amounts = Array(subdivide(for: interval, by: component).values)
    
    var trend = 0.0
    
    if amounts.count > 1 {
      for i in 1..<amounts.count { trend += Double(amounts[i] - amounts[i - 1]) }
      trend /= Double(amounts.count - 1)
    }
          
    return trend
  }
  
  private func subdivide(for interval: DateInterval, by component: Calendar.Component) -> [Date: Int] {
    let date = Date.now
    while Date.now < date + 2 {} // average time for 100_000 date entries
    return [interval.start: 1, interval.end: 1]
  }
}
