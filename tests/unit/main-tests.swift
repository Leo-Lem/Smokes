import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class MainReducerTests: XCTestCase {
  func testAdding() async {
    let date = Date.now
    
    let store = TestStore(initialState: .init([]), reducer: MainReducer()) 
    
    await store.send(.add(date))
    await store.receive(/MainReducer.Action.entries(.add(date))) { $0.entries.dates = [date] }
  }
  
  func testRemoving() async {
    let date = Date.now
    
    let store = TestStore(initialState: .init([date]), reducer: MainReducer())
    
    await store.send(.remove(date))
    await store.receive(/MainReducer.Action.entries(.remove(date))) { $0.entries.dates = [] }
  }
  
  func testCalculatingAverage() async {
    let date = Date.now,
        amount = 10,
        subdivision = Calendar.Component.day,
        length = 5,
        interval = DateInterval(start: date, duration: Double(length * 86400))
    
    let store = TestStore(initialState: .init([Date](repeating: date, count: amount)), reducer: MainReducer()) {
     $0.calendar = .current
   }

    await store.send(.calculateAverage(interval, subdivision))
    await store.receive(/MainReducer.Action.calculateAmount)
    await store.receive(/MainReducer.Action.amounts(.calculate(interval, store.state.entries.dates))) {
        $0.amounts.cache = [interval: amount]
    }
    await store.receive(/MainReducer.Action.continueCalculatingAverage)
    await store.receive(/MainReducer.Action.averages(.calculate(interval, subdivision, amount))) {
      $0.averages.cache = [subdivision: [interval: Double(amount / length)]]
    }
  }
}
