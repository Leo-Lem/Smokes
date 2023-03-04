import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class AveragesTests: XCTestCase {
  func testCalculating() async {
    let date = Date.now,
        amount = 10,
        subdivision = Calendar.Component.day,
        length = 5,
        interval = DateInterval(start: date, duration: Double(length * 86400))
    
    let store = TestStore(initialState: .init(), reducer: Averages()) {
      $0.calendar = .current
    }
    
    await store.send(.calculate(interval, subdivision, amount)) {
      $0.cache = [subdivision: [interval: Double(amount / length)]]
    }
  }
}
