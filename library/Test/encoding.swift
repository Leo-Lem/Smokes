// Created by Leopold Lemmermann on 23.02.23.

@testable import Code
import Foundation
import Testing

struct EncodingTest {
  @Test(arguments: Encoding.allCases)
  func whenEncodingEntries_thenDataIsNotEmpty(encoding: Encoding) async throws {
    let base = Date(timeIntervalSinceReferenceDate: 0)
    let entries = [base - 999_999, base, base + 999_999]
    #expect(try encoding.encode(entries).count > 0)
  }

  @Test(arguments: Encoding.allCases)
  func whenEncodingEmptyEntries_thenDataIsEmpty(encoding: Encoding) async throws {
    #expect(try encoding.encode([]).isEmpty)
  }

  /// Some encodings remove certain information, so exact dates would not match. The total should always stay the same.
  @Test(arguments: Encoding.allCases)
  func whenDecodingValidData_thenReturnsCorrectEntries(encoding: Encoding) async throws {
    let base = Date(timeIntervalSinceReferenceDate: 0)
    let entries = [base - 999_999, base, base + 999_999]
    let data = try encoding.encode(entries)
    #expect(try encoding.decode(data).count == entries.count)
  }

  @Test(arguments: Encoding.allCases)
  func whenDecodingEmptyData_thenReturnsEmptyEntries(encoding: Encoding) async throws {
    #expect(try encoding.decode(Data()).isEmpty)
  }
}
