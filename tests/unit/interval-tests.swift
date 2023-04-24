// Created by Leopold Lemmermann on 02.04.23.

@testable import Smokes
import Dependencies
import XCTest

@MainActor
final class IntervalTests: XCTestCase {
  func testCount() async throws {
    withDependencies { $0.calendar = .current } operation: {
      let interval = Interval.fromTo(.init(start: Date(timeIntervalSince1970: 0), duration: 86400 * 800))
      
      for (subdivision, value) in zip(Subdivision.allCases, [800, 115, 27, 3]) {
        XCTAssertEqual(interval.count(by: subdivision), value)
      }
    }
  }
  
  func testEnumerating() async throws {
    withDependencies { $0.calendar = .current} operation: {
      let interval = Interval.fromTo(.init(start: Date(timeIntervalSince1970: 0), duration: 86400 * 800))
      
      for (subdivision, value) in zip(Subdivision.allCases, [801, 115, 27, 3]) {
        let enumerated = interval.enumerate(by: subdivision)
        XCTAssertEqual(enumerated?.count, value)
      }
    }
  }
  
  func testGettingNext() async throws {
    withDependencies { $0.calendar = .current} operation: {
      let date = Date.now
      let interval = Interval.day(date)
      
      XCTAssertEqual(interval.next(), .day(date + 86400))
    }
  }
  
  func testGettingPreviousWithBounds() async throws {
    withDependencies { $0.calendar = .current} operation: {
      let date = Date(timeIntervalSinceReferenceDate: 0)
      let interval = Interval.month(date)
      let bounds = Interval.year(date)
      
      XCTAssertNil(interval.previous(in: bounds))
    }
  }
}
