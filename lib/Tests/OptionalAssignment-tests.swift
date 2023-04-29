// Created by Leopold Lemmermann on 29.04.23.

import XCTest
@testable import SmokesLibrary

final class OptionalAssignmentTests: XCTestCase {
  func test_whenAssigningOptionally_thenIsAssigned() throws {
    var value = 1
    let newValue = Optional(2)
    
    value ?= newValue
    
    XCTAssertEqual(value, newValue)
  }
  
  func test_whenAssigningNilOptionally_thenIsNotAssigned() throws {
    var value = 1
    let newValue = Optional<Int>.none
    
    value ?= newValue
    
    XCTAssertNotEqual(value, newValue)
  }
}
