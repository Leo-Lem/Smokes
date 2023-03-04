// Created by Leopold Lemmermann on 28.02.23.

import XCTest

final class AmountPerformanceTests: XCTestCase {
  func testPerformance() async {
    let dates = [Date](sortedDates: 1_000_000)

    XCTAssertEqual(amount(for: .example, dates: dates), amountByFilter(for: .example, dates: dates))

    measure {
      _ = amount(for: .example, dates: dates)
//      _ = amountByFilter(for: .example, dates: dates)
    }
  }

  private func amount(for interval: DateInterval, dates: [Date]) -> Int {
    (dates.firstIndex { interval.end < $0 } ?? dates.endIndex) - (dates.firstIndex { interval.start <= $0 } ?? 0)
  }

  private func amountByFilter(for interval: DateInterval, dates: [Date]) -> Int {
    dates.filter { interval.start <= $0 && $0 < interval.end }.count
  }
}
