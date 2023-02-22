@testable import Smokes
import XCTest

final class TrackingTests: XCTestCase {
  let feature = MainReducer()
  var state: MainReducer.State!
  
  override func setUp() { state = .init() }
  
  func testIncrementing() {
    let date = Date.now
    let amount = state.amount(for: date, in: .day)
    _ = feature.reduce(into: &state, action: .add(date))
    
    XCTAssertEqual(amount + 1, state.amount(for: date, in: .day))
  }
  
  func testDecrementing() {
    let date = Date.now
    _ = feature.reduce(into: &state, action: .add(date))
    
    let amount = state.amount(for: date, in: .day)
    _ = feature.reduce(into: &state, action: .remove(date))
    
    XCTAssertEqual(amount - 1, state.amount(for: date, in: .day))
  }
  
  func testAmount() {
    let date = Date.now, n = Int.random(in: 1..<100)
    
    for _ in 0..<n {
      _ = feature.reduce(into: &state, action: .add(date))
    }
    
    let amount = state.amount(for: .now, in: .day)
    
    XCTAssertEqual(amount, n)
  }
  
  func testAverage() {
    let date = Date.now, n = Int.random(in: 1..<100)
    
    for _ in 0..<n {
      _ = feature.reduce(into: &state, action: .add(date))
    }
    
    let average = state.average(for: .now, in: .day, by: .hour)
    
    XCTAssertEqual(average, Double(n) / 24)
  }
  
  func testData() {
  }
  
  private func createTestData() {
    state.entries = Array(repeating: (), count: 500).map {
      Date(timeIntervalSinceNow: -Double.random(in: 1..<9999999))
    }
  }
}
