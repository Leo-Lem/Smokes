import XCTest

@MainActor class SmokesUITests: XCTestCase {
  var app: XCUIApplication!

  override func setUp() async throws {
    app = XCUIApplication()
    app.launch()
  }

  func addingAndRemovingSmokes() async throws {}
}
