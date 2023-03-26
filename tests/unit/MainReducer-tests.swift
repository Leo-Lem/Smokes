import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class MainReducerTests: XCTestCase {
  func testCalculatingAmount() async {
    let interval = DateInterval(start: .distantPast, duration: 86400 * 10),
        amount = 1000,
        dates = (0..<amount).map { _ in interval.start + Double.random(in: 0..<interval.duration) }
    
    let store = TestStore(initialState: .init(), reducer: MainReducer())

    await store.send(.entries(.set(dates))) { $0.entries.unwrapped = dates }
    await store.receive(/.entries(.updateAmounts()), timeout: 1)
    await store.send(.calculateAmount(interval)) { $0.amounts = [interval: amount] }
  }
}
