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
  
  func testCalculatingUntil() async {
    let store = TestStore(initialState: .init(), reducer: Amounts()) {
      $0.calendar = .current
    }
    
    let date = Date.now, interval = DateInterval(start: .init(timeIntervalSinceReferenceDate: 0), end: date + 1)
    
    await store.send(.calculateUntil(interval.end, interval.start, [date]))
    await store.receive(/Amounts.Action.calculate) {
      $0.cache = [interval: 1]
    }
  }
}
