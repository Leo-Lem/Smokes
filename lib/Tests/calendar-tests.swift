// Created by Leopold Lemmermann on 28.04.23.

import XCTest
@testable import SmokesLibrary

final class CalendarTests: XCTestCase {
  private var cal: Calendar!
  
  override func setUp() { cal = .current }
  
  func test_givenAValidComponent_whenSettingStartOf_thenReturnsDate() throws {
    for comp in [Calendar.Component.day, .weekOfYear, .month, .year] {
      XCTAssertNotNil(cal.start(of: comp, for: .now), "\(comp) returned nil")
    }
  }
  
  func test_givenAnInvalidComponent_whenSettingStartOf_thenReturnsNil() throws {
    for comp in [Calendar.Component.calendar, .weekdayOrdinal] {
      XCTAssertNil(cal.start(of: comp, for: .now), "\(comp) did not return nil")
    }
  }
  
  func test_givenAValidComponent_whenSettingEndOf_thenReturnsDate() throws {
    for comp in [Calendar.Component.day, .weekOfYear, .month, .year] {
      XCTAssertNotNil(cal.end(of: comp, for: .now), "\(comp) returned nil")
    }
  }
  
  func test_givenAnInvalidComponent_whenSettingEndOf_thenReturnsNil() throws {
    for comp in [Calendar.Component.era, .calendar, .weekdayOrdinal] {
      XCTAssertNil(cal.end(of: comp, for: .now), "\(comp) did not return nil")
    }
  }
}
