// Created by Leopold Lemmermann on 23.02.23.

@testable import SmokesDependencies
import XCTest

@MainActor
final class EncodingTests: XCTestCase {
  func test_whenEncodingEntries_thenDataIsNotEmpty() async throws {
    let base = Date(timeIntervalSinceReferenceDate: 0)
    let entries = [base - 999_999, base, base + 999_999]
    
    for encoding in Encoding.allCases {
      XCTAssertFalse(try encoding.encode(entries).isEmpty)
    }
  }
  
  func test_whenEncodingEmptyEntries_thenDataIsEmpty() async throws {
    for encoding in Encoding.allCases {
      XCTAssertTrue(try encoding.encode([]).isEmpty)
    }
  }
  
  // some encodings remove certain information,
  // so the exact dates would not be matched
  // but the total should always stay the same
  func test_whenDecodingValidData_thenReturnsCorrectTotal() async throws {
    let base = Date(timeIntervalSinceReferenceDate: 0)
    let entries = [base - 999_999, base, base + 999_999]
    
    for encoding in Encoding.allCases {
      let data = try encoding.encode(entries)
      XCTAssertEqual(try encoding.decode(data).count, entries.count)
    }
  }
  
  func test_whenDecodingEmptyData_thenReturnsEmptyEntries() async throws {
    for encoding in Encoding.allCases {
      XCTAssertTrue(try encoding.decode(Data()).isEmpty)
    }
  }
}
