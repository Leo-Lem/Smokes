import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class AmountsTests: XCTestCase {
  func testCalculating() async {
    let store = TestStore(initialState: .init(), reducer: Amounts())
    
    let date = Date.now, interval = DateInterval(start: date, end: .distantFuture)
    await store.send(.calculate(interval, [date])) { $0.cache = [interval: 1] }
  }
}
