// Created by Leopold Lemmermann on 28.02.23.

import XCTest

final class PerformanceTests: XCTestCase {
  let dates = (0..<100_000).map { _ in Date.now + Double.random(in: -100_000_000..<100_000_000) }
}

private extension DateInterval {
  static let example = Calendar.current.dateInterval(of: .month, for: .now)!
}

extension PerformanceTests {
  func testFindingClosestDate() {
    measure {
      _ = findClosestDate(to: .now)
    }
  }
  
  private func findClosestDate(to date: Date) -> Date? {
    dates.lazy.sorted().first { $0 < date }
  }
}
  
extension PerformanceTests {
  func testAmounting() async {
    measure {
      _ = self.amount(for: .example)
    }
  }

  private func amount(for interval: DateInterval) -> Int {
    dates.filter { interval.start <= $0 && $0 < interval.end }.count
  }
}

extension PerformanceTests {
  func testAveraging() {
    measure {
      _ = self.average(for: .example, by: .day)
    }
  }
  
  private func average(for interval: DateInterval, by component: Calendar.Component) -> Double {
    let cal = Calendar.current
    let amount = amount(for: interval)
    let length = cal.dateComponents([component], from: interval.start, to: interval.end).value(for: component) ?? 1
    
    return Double(amount) / Double(length == 0 ? 1 : length)
  }
}

extension PerformanceTests {
  func testSubdividing() {
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
}

extension PerformanceTests {
  func testTrending() {
    measure {
      _ = trend(for: .example, by: .day)
    }
  }

  private func trend(for interval: DateInterval, by component: Calendar.Component) -> Double {
    let amounts = Array(subdivide(for: interval, by: component).values)
    
    var trend = 0.0
    
    if amounts.count > 1 {
      for i in 1..<amounts.count {
        trend += Double(amounts[i] - amounts[i - 1])
      }
      trend /= Double(amounts.count - 1)
    }
          
    return trend
  }
}
