// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
@testable import Smokes
import UniformTypeIdentifiers
import XCTest

final class SmokesFileTests: XCTestCase {
  func testCreatingTextFile() throws {
    try withDependencies { $0.calendar = .current } operation: {
      let entries = [Date.distantPast, .now, .distantFuture], format = UTType.utf8PlainText
      
      let file = try SmokesFile(entries, format: format)
      XCTAssertEqual(file.format, format)
      XCTAssertEqual(file.entries, entries)
      XCTAssertTrue(file.preview.split(separator: "\n").count == entries.count)
    }
  }
  
  func testCreatingJSONFile() throws {
    try withDependencies { $0.calendar = .current } operation: {
      let entries = [Date.distantPast, .now, .distantFuture], format = UTType.json
      
      let file = try SmokesFile(entries, format: format)
      XCTAssertEqual(file.format, format)
      XCTAssertEqual(file.entries, entries)
      XCTAssertTrue(file.preview.split(separator: "\n").count == 10)
    }
  }
}
