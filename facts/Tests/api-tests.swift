import XCTest
import XCTVapor
@testable import FactsAPI

@MainActor
final class FactsAPITests: XCTestCase {
  private var app: Application!
  
  override func setUpWithError() throws {
    app = Application(.testing)
    app.configure(Facts())
  }
  
  override func tearDown() {
    app.shutdown()
  }
  
  func test_whenCallingRoot_thenReturnsSomething() async throws {
    try app.test(.GET, "") { res in
      XCTAssertEqual(res.status, .ok)
      XCTAssertFalse(res.body.string.isEmpty)
    }
  }
  
  func test_whenGettingEnglishFact_thenReturnsSomething() async throws {
    try app.test(.GET, "en") { res in
      XCTAssertEqual(res.status, .ok)
      XCTAssertFalse(res.body.string.isEmpty)
    }
  }
  
  func test_whenGettingGermanFact_thenReturnsSomething() async throws {
    try app.test(.GET, "de") { res in
      XCTAssertEqual(res.status, .ok)
      XCTAssertFalse(res.body.string.isEmpty)
    }
  }
}
