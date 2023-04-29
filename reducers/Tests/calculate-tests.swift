// Created by Leopold Lemmermann on 28.04.23.

import ComposableArchitecture
@testable import SmokesReducers
import XCTest

@MainActor
final class CalculateTest: XCTestCase {
  private let date = Date(timeIntervalSinceReferenceDate: 0)
  
  private var calculate: Calculate!
  
  override func setUp() { calculate = .init() }
  
  func test_whenFiltering_thenReturnsCorrect() throws {
    let entries = [date, date + 86400, date + 2 * 86400, date + 3 * 86400, date + 4 * 86400]
    var filteredEntries = calculate.filter(interval: .from(date + 2 * 86400), entries: entries)

    XCTAssertEqual(filteredEntries.count, 3)
    XCTAssertEqual(filteredEntries[0], entries[2])
    XCTAssertEqual(filteredEntries[1], entries[3])
    XCTAssertEqual(filteredEntries[2], entries[4])
    
    filteredEntries = calculate.filter(interval: .to(date + 86400), entries: entries)
    
    XCTAssertEqual(filteredEntries.count, 2)
    XCTAssertEqual(filteredEntries[0], entries[0])
    XCTAssertEqual(filteredEntries[1], entries[1])
    
    XCTAssertEqual(calculate.filter(interval: .alltime, entries: []).count, 0)
  }
  
  func test_whenFilteringAmounts_thenReturnsFilteredAmounts() throws {
    let amounts = [Interval.day(date): 10, .day(date - 86400): 20, .week(date): 30]
    let parameters = IntervalAndSubdivision(.week(date), .day)
    
    let expectedAmounts = [
      Interval.day(date - 86400): 20, .day(date): 10, .day(date + 86400): 0, .day(date + 2 * 86400): 0,
      .day(date + 3 * 86400): 0, .day(date + 4 * 86400): 0, .day(date + 5 * 86400): 0
    ]
      
    XCTAssertEqual(calculate.filterAmounts(parameters: parameters, amounts: amounts), expectedAmounts)
    
    XCTAssertNil(calculate.filterAmounts(parameters: .init(.alltime, .day), amounts: [:]))
  }
  
  func test_whenAmounting_thenReturnsCorrect() throws {
    let entries = [date, date + 86400, date + 2 * 86400, date + 3 * 86400, date + 4 * 86400]
    
    XCTAssertEqual(calculate.amount(interval: .to(date + 2 * 86400), entries: entries), 3)
    XCTAssertEqual(calculate.amount(interval: .from(date + 3 * 86400), entries: entries), 2)
    XCTAssertEqual(calculate.amount(interval: .alltime, entries: entries), 5)
    XCTAssertEqual(calculate.amount(interval: .alltime, entries: []), 0)
  }
  
  func test_whenAveraging_thenReturnsCorrect() throws {
    let amounts = [Interval.day(date): 10, .day(date - 86400): 20, .week(date): 30]
    
    XCTAssertEqual(calculate.average(parameters: .init(.week(date), .day), amounts: amounts)!, 4.3, accuracy: 0.1)
    XCTAssertNil(calculate.average(parameters: .init(.month(date), .day), amounts: [:]))
    XCTAssertNil(calculate.average(parameters: .init(.alltime, .day), amounts: [.alltime: 100]))
    XCTAssertEqual(calculate.average(parameters: .init(.day(date), .day), amounts: amounts), .infinity)
  }
  
  func test_whenTrending_thenReturnsCorrect() throws {
    let amounts = [Interval.day(date): 10, .day(date - 86400): 20, .week(date): 30]
    
    XCTAssertEqual(calculate.trend(parameters: .init(.week(date), .day), amounts: amounts)!, -3.3, accuracy: 0.1)
    XCTAssertNil(calculate.trend(parameters: .init(.alltime, .day), amounts: [:]))
    XCTAssertEqual(calculate.trend(parameters: .init(.day(date), .day), amounts: amounts)!, .infinity)
    XCTAssertEqual(calculate.trend(parameters: .init(.alltime, .day), amounts: amounts)!, .infinity)
    
  }
  
  func test_whenAveragingBreak_thenReturnsCorrect() throws {
    let amounts = [Interval.day(date): 10, .day(date - 86400): 20, .week(date): 30, .month(date): 0]
    
    XCTAssertEqual(calculate.averageBreak(interval: .week(date), amounts: amounts)!, 20160, accuracy: 0.1)
    XCTAssertNil(calculate.averageBreak(interval: .day(date), amounts: [:]))
    XCTAssertEqual(calculate.averageBreak(interval: .month(date), amounts: amounts), .infinity)
  }
  
  func test_whenCalculatingBreak_thenReturnsCorrect() throws {
    let state = Calculate.State([date, date + 86400, date + 2 * 86400, date + 3 * 86400, date + 4 * 86400])
    
    XCTAssertEqual(state.break(date: date + 3.5 * 86400), 43200)
    XCTAssertEqual(Calculate.State().break(date: date), .infinity)
  }
  
  func test_whenCalculatingLongestBreak_thenReturnsCorrect() throws {
    let state = Calculate.State([date, date + 86400, date + 3 * 86400, date + 4 * 86400])
    
    XCTAssertEqual(state.longestBreak(until: date + 4*86400), 172800)
    XCTAssertEqual(Calculate.State().longestBreak(until: date), .infinity)
    XCTAssertEqual(Calculate.State([date]).longestBreak(until: date + 9999), 9999)
  }
}
