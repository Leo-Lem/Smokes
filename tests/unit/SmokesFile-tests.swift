// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
@testable import Smokes
import UniformTypeIdentifiers
import XCTest

final class SmokesFileTests: XCTestCase {
  func testCreatingTextFile() throws {
    withDependencies { $0.calendar = .current } operation: {
      let amounts = [Date.now - 86400: 10, .now: 8, .now + 86400: 7]
      
      let file = SmokesFile(amounts)
      XCTAssertEqual(file.amounts, amounts)
      XCTAssertFalse(file.generatePreview(for: .plainText).isEmpty)
      XCTAssertFalse(file.generatePreview(for: .json).isEmpty)
    }
  }
}
