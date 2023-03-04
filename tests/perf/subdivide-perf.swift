// Created by Leopold Lemmermann on 28.02.23.

import XCTest

final class SubdividePerformanceTests: XCTestCase {
  func testPerformance() {
    measure {
      _ = subdivide(for: .example, by: .day)
    }
  }
  
  private func subdivide(for interval: DateInterval, by component: Calendar.Component) -> [Date: Int] {
    let cal = Calendar.current
    var amounts = [Date: Int](), date = interval.start
        
    while date < interval.end {
      let nextDate = cal.date(byAdding: component, value: 1, to: date)!
      amounts[date] = amount(for: DateInterval(start: date, end: nextDate))
      date = nextDate
    }

    return amounts
  }
  
  private func amount(for interval: DateInterval) -> Int { 1 }
}
