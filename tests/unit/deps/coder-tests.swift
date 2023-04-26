import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class CoderTests: XCTestCase {
  func testEncodingToExactFile() throws {
    withDependencies {
      $0.calendar = .current
      $0.date = .constant(.now)
    } operation: {
      let coder = ExactCoder()
      
      let data = coder.encode([.now, .endOfToday, .startOfToday])
      
      XCTAssertFalse(data.isEmpty)
    }
  }
  
  func testDecodingFromExactFile() throws {
    withDependencies {
      $0.calendar = .current
      $0.date = .constant(.now)
    } operation: {
      let coder = ExactCoder()
      let entries = [Date.now, .endOfToday, .startOfToday]
      let encoded = coder.encode(entries)
      
      let decoded = coder.decode(encoded)
      
      for (entry, decodedValue) in zip(entries.sorted(by: >), decoded) {
        XCTAssertEqual(
          entry.timeIntervalSinceReferenceDate,
          decodedValue.timeIntervalSinceReferenceDate,
          accuracy: 1
        )
      }
    }
  }
  
  func testEncodingToDailyFile() throws {
    withDependencies {
      $0.calendar = .current
      $0.date = .constant(.now)
    } operation: {
      let coder = DailyCoder()
      
      let data = coder.encode([.now, .endOfToday, .startOfToday])
      
      XCTAssertFalse(data.isEmpty)
    }
  }
  
  func testDecodingFromDailyFile() throws {
    withDependencies {
      $0.calendar = .current
      $0.date = .constant(.now)
    } operation: {
      let coder = DailyCoder()
      let entries = [Date.now, .endOfToday, .startOfToday]
      let encoded = coder.encode(entries)
      
      let decoded = coder.decode(encoded)
      
      XCTAssertFalse(decoded.isEmpty)
      
      for decodedValue in decoded {
        XCTAssertTrue(Calendar.current.isDate(decodedValue, inSameDayAs: .now))
      }
    }
  }
}
