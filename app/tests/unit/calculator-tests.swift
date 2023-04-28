// Created by Leopold Lemmermann on 26.03.23.

import Dependencies
import Foundation
@testable import Smokes
import XCTest

@MainActor
final class CalculateTests: XCTestCase {
  private let calculator = Calculator.liveValue
  
  func testAmounting() async throws {
    let base = Date(timeIntervalSinceReferenceDate: 0)
    
    let calculatedAmount = calculator.amount(
      [base, base + 999, base + 999 * 2], .
        fromTo(.init(start: base, end: base + 1000))
    )
    
    XCTAssertEqual(calculatedAmount, 2)
  }
  
  func testAmountingEmpty() async throws {
    let calculatedAmount = calculator.amount(
      [],
      .alltime
    )
    
    XCTAssertEqual(calculatedAmount, 0)
  }
  
  func testAveraging() async throws {
    withDependencies { $0.calendar = .current } operation: {
      let amount = 100
      
      let average = calculator.average(
        amount,
        .month(Date(timeIntervalSince1970: 0)),
        .day
      )
      
      XCTAssertEqual(average, Double(amount) / 30, accuracy: Double(amount) / 1000)
    }
  }
  
  func testAveragingEmpty() async throws {
    withDependencies { $0.calendar = Calendar.current } operation: {
      let average = calculator.average(
        0, .day(.now), .day
      )
      
      XCTAssertEqual(average, .infinity)
    }
  }
  
  func testAveragingOpenInterval() async throws {
    withDependencies { $0.calendar = Calendar.current } operation: {
      let average = calculator.average(
        0, .alltime, .day
      )
      
      XCTAssertEqual(average, .infinity)
    }
  }
  
  func testTrendingPositive() async throws {
    withDependencies { $0.calendar = Calendar.current } operation: {
      let base = Date(timeIntervalSince1970: 0)
      
      let trend = calculator.trend(
        [Interval.day(base): 1, Interval.day(base + 86400): 2, Interval.day(base + 86400 * 2): 3],
        .fromTo(.init(start: base, duration: 86400 * 2)),
        .day
      )
      
      XCTAssertEqual(trend, 1)
    }
  }
  
  func testTrendingNegative() async throws {
    withDependencies { $0.calendar = Calendar.current } operation: {
      let base = Date(timeIntervalSince1970: 0)
      
      let trend = calculator.trend(
        [Interval.day(base): 3, Interval.day(base + 86400): 2, Interval.day(base + 86400 * 2): 1],
        .fromTo(.init(start: base, duration: 86400 * 2)),
        .day
      )
      
      XCTAssertEqual(trend, -1)
    }
  }
  
  func testTrendingEmpty() async throws {
    withDependencies { $0.calendar = Calendar.current } operation: {
      let trend = calculator.trend(
        [:],
        .alltime,
        .day
      )
      
      XCTAssertEqual(trend, .infinity)
    }
  }
  
  func testCalculatingSinceLast() async throws {
    let entries = [Date(timeIntervalSinceReferenceDate: 0)]
    let time = 86400.0
    
    let sinceLast = calculator.sinceLast(entries, Date(timeIntervalSinceReferenceDate: time))
    
    XCTAssertEqual(sinceLast, time)
  }
  
  func testCalculatingLongestBreak() async throws {
    let time = 86400.0
    let entries = [
      Date(timeIntervalSinceReferenceDate: 0),
      Date(timeIntervalSinceReferenceDate: time / 3),
      Date(timeIntervalSinceReferenceDate: time)
    ]
    
    let longestBreak = calculator.longestBreak(entries)
    
    XCTAssertEqual(longestBreak, time / 3 * 2)
  }
  
  func testAveragingTimeBetween() async throws {
    let averageTimeBetween = calculator.averageTimeBetween(
      62,
      .fromTo(.init(start: .init(timeIntervalSince1970: 0), duration: 86400 * 31))
    )
    
    XCTAssertEqual(averageTimeBetween, 86400 / 2)
  }
}
