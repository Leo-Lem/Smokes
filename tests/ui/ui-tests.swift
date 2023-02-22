import XCTest

final class SmokesUITests: XCTestCase {
  var app: XCUIApplication!

  override func setUp() async throws {
    app = XCUIApplication()
    app.launch()

    // wait for app set up
  }

  func testExample() throws {}
}
