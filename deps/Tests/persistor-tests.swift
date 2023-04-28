// Created by Leopold Lemmermann on 23.02.23.

@testable import SmokesDependencies
import XCTest

@MainActor
final class PersistorTests: XCTestCase {
  private let persistor = Persistor.liveValue
  
  func testWritingAndReadingDates() async throws {
    let dates = [Date.now, .now, .now]
    
    try await persistor.writeDates(dates)
    let readDates = try await persistor.readDates()
    
    XCTAssertEqual(readDates, dates)
  }
}
