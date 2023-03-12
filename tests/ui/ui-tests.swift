import XCTest

@MainActor
final class SmokesUITests: XCTestCase {
  var app: XCUIApplication!

  override func setUp() async throws {
    app = XCUIApplication()
    app.launch()
  }

  func testAddingAndRemoving() throws {
    dashboardButton.tap()
    
    guard let dayAmount = getAmount(from: "today") else { throw XCTSkip("Cannot find day amount") }
    
    app.buttons["add"].tap() // adding 1
    XCTAssertEqual(dayAmount + 1, getAmount(from: "today"))
    
    app.buttons["remove"].tap() // removing 1
    XCTAssertEqual(dayAmount, getAmount(from: "today"))
  }
  
  func testOpeningAndClosingMonthPlot() {
    dashboardButton.tap()
    
    app.buttons["show-plot-button"].tap() // opening plot
    app.otherElements["no description"].firstMatch.tap() // closing plot again
    
    XCTAssertFalse(app.otherElements["no description"].firstMatch.exists, "Plot is still visible.")
  }
  
  func testExportingAndImporting() {
    dashboardButton.tap()
    
    app.buttons["show-porter-button"].tap()
    
    XCTAssertTrue(app.buttons["export-button"].exists)
    XCTAssertTrue(app.buttons["import-button"].exists)
    XCTAssertTrue(app.otherElements["format-picker"].exists)
  }
  
  func testSelectingDaysInHistory() throws {
    historyButton.tap()
    
    guard let initial = getValue(from: "day-picker") else { throw XCTSkip("Cannot find date") }
    
    app.buttons["previous-day-button"].tap()
    XCTAssertFalse(initial == getValue(from: "day-picker"))
    
    app.buttons["next-day-button"].tap()
    XCTAssertEqual(initial, getValue(from: "day-picker"))
  }
  
  func testAddingAndRemovingHistory() throws {
    historyButton.tap()
    
    guard let dayAmount = getAmount(from: "this day") else { throw XCTSkip("Cannot find day amount") }
    
    app.buttons["start-modifying-button"].tap()
    
    app.buttons["add"].tap()
    XCTAssertEqual(dayAmount + 1, getAmount(from: "this day"))
    
    app.buttons["remove"].tap()
    XCTAssertEqual(dayAmount, getAmount(from: "this day"))
    
    app.buttons["stop-modifying-button"].tap()
    
    XCTAssertFalse(app.buttons["add"].exists)
  }
  
  func testChangingMonthsAndAlltimeStats() throws {
    statsButton.tap()
    
    guard let initial = getValue(from: "month-picker") else { throw XCTSkip("Cannot find date") }
    
    app.buttons["previous-month-button"].tap()
    XCTAssertEqual(app.staticTexts.count, 6)
    
    app.buttons["next-month-button"].tap()
    XCTAssertEqual(initial, getValue(from: "month-picker"))
    
    app.buttons["select-alltime-button"].tap()
    XCTAssertEqual(app.staticTexts.count, 9)
  }

  private var dashboardButton: XCUIElement { app.tabBars.buttons["dashboard-tab-button"] }
  private var historyButton: XCUIElement { app.tabBars.buttons["history-tab-button"] }
  private var statsButton: XCUIElement { app.tabBars.buttons["stats-tab-button"] }
  
  private func getAmount(from label: String) -> Int? { getValue(from: label).flatMap(Int.init) }
  private func getValue(from label: String) -> String? {
    let element = app.descendants(matching: .any)[label].firstMatch
    _ = element.waitForExistence(timeout: 3)
    return element.value as? String
  }
}
