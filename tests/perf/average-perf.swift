// Created by Leopold Lemmermann on 28.02.23.

import XCTest

final class AveragePerformanceTests: XCTestCase {
  func testPerformance() {
    measure {
      _ = average(for: .example, by: .day)
    }
  }
  
  private func average(for interval: DateInterval, by component: Calendar.Component) -> Double {
    let cal = Calendar.current
    let length = cal.dateComponents([component], from: interval.start, to: interval.end).value(for: component) ?? 1
    
    return Double(amount(for: interval)) / Double(length == 0 ? 1 : length)
  }
  
  private func amount(for interval: DateInterval) -> Int { 1 }
}
