// Created by Leopold Lemmermann on 28.04.23.

import XCTest

@testable import Calculate

// TODO: integrate with dependencies

@MainActor
final class CalculateTest: XCTestCase {
  private let calculate = Calculate.liveValue
  
  private let date = Date(timeIntervalSinceReferenceDate: 0)
  private var entries: [Date] { (-10..<10).map { date + TimeInterval($0 * 86400) } }
  
  func test_whenFiltering_thenReturnsCorrect() throws {
    XCTAssertEqual(calculate.filter(.from(date + 2 * 86400), entries).count, 8)
    XCTAssertEqual(calculate.filter(.to(date + 86400), entries).count, 12)
    XCTAssertEqual(calculate.filter(.alltime, []), [])
  }

  func test_whenFilteringAmounts_thenReturnsFilteredAmounts() async throws {
    var amounts = calculate.amounts(.week(date), .day, entries)
    XCTAssertEqual(amounts?.count, 7)
    amounts = calculate.amounts(.alltime, .day, [])
    XCTAssertNil(amounts)
  }
  
  func test_whenAmounting_thenReturnsCorrect() throws {
    XCTAssertEqual(calculate.amount(.to(date + 2 * 86400), entries), 13)
    XCTAssertEqual(calculate.amount(.from(date + 3 * 86400), entries), 7)
    XCTAssertEqual(calculate.amount(.alltime, entries), 20)
    XCTAssertEqual(calculate.amount(.alltime, []), 0)
  }
  
  func test_whenAveraging_thenReturnsCorrect() throws {
    XCTAssertEqual(calculate.average(.week(date), .day, entries)!, 1, accuracy: 0.1)
    XCTAssertEqual(calculate.average(.alltime, .day, entries), 0)
    XCTAssertEqual(calculate.average(.day(date), .day, entries), .infinity)
  }
  
  func test_whenTrending_thenReturnsCorrect() throws {
    XCTAssertEqual(calculate.trend(.week(date), .day, entries)!, -0.0, accuracy: 0.1)
    XCTAssertNil(calculate.trend(.alltime, .day, entries))
    XCTAssertEqual(calculate.trend(.day(date), .day, entries)!, .infinity)
  }
  func test_whenCalculatingBreak_thenReturnsCorrect() throws {
    XCTAssertEqual(calculate.break(date + 3.5 * 86400, entries), 43200)
    XCTAssertEqual(calculate.break(date, []), .infinity)
  }

  func test_whenCalculatingLongestBreak_thenReturnsCorrect() throws {
    XCTAssertEqual(calculate.longestBreak(date + 4*86400, entries), 86400)
    XCTAssertEqual(calculate.longestBreak(date, []), .infinity)
    XCTAssertEqual(calculate.longestBreak(date + 9999, entries), 86400)
  }
  
  func test_whenAveragingBreak_thenReturnsCorrect() throws {
    XCTAssertEqual(calculate.averageBreak(.week(date), entries), 86399.8, accuracy: 0.1)
    XCTAssertEqual(calculate.averageBreak(.day(date), entries), .infinity)
  }
}
