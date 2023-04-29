// Created by Leopold Lemmermann on 28.04.23.

@testable import SmokesLibrary
import XCTest

@available(iOS 16, *)
final class CalendarTests: XCTestCase {
  private var cal: Calendar {
    var cal = Calendar(identifier: .iso8601)
    cal.timeZone = .gmt
    return cal
  }
  private let date = Date(timeIntervalSinceReferenceDate: 9_999_999)
  
  func test_givenAValidComponent_whenGettingStartOf_thenReturnsDate() throws {
    let expected: [Calendar.Component: TimeInterval] = [
      .day: 9936000,
      .weekOfYear: 9676800,
      .month: 7776000,
      .year: 0
    ]
    
    for (comp, time) in expected {
      XCTAssertEqual(cal.start(of: comp, for: date), Date(timeIntervalSinceReferenceDate: time))
    }
  }
  
  func test_givenAnInvalidComponent_whenGettingStartOf_thenReturnsNil() throws {
    for comp in [Calendar.Component.calendar, .weekdayOrdinal] {
      XCTAssertNil(cal.start(of: comp, for: date), "\(comp) did not return nil")
    }
  }
  
  func test_givenAValidComponent_whenGettingEndOf_thenReturnsDate() throws {
    let expected: [Calendar.Component: TimeInterval] = [
      .day: 10022399,
      .weekOfYear: 10281599,
      .month: 10367999,
      .year: 31535999
    ]
        
    for (comp, time) in expected {
      XCTAssertEqual(cal.end(of: comp, for: date), Date(timeIntervalSinceReferenceDate: time))
    }
  }
  
  func test_givenAnInvalidComponent_whenGettingEndOf_thenReturnsNil() throws {
    for comp in [Calendar.Component.calendar, .weekdayOrdinal] {
      XCTAssertNil(cal.end(of: comp, for: date), "\(comp) did not return nil")
    }
  }
}
