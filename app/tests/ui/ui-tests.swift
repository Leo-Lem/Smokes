import XCTest

@MainActor
final class SmokesUITests: XCTestCase {
  var app: XCUIApplication!

  override func setUp() async throws {
    app = XCUIApplication()
    app.launch()
  }

  func test_addingAndRemovingSmoke() throws {}
  
}
