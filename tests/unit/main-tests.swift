import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class MainReducerTests: XCTestCase {
  func testAdding() async {
    let store = TestStore(initialState: .init([]), reducer: MainReducer()) 
    
    let date = Date.now
    await store.send(.add(date))
    await store.receive(/MainReducer.Action.entries(.add(date))) { $0.entries.dates = [date] }
  }
  
  func testRemoving() async {
    let date = Date.now
    let store = TestStore(initialState: .init([date]), reducer: MainReducer())
    
    await store.send(.remove(date))
    await store.receive(/MainReducer.Action.entries(.remove(date))) { $0.entries.dates = [] }
  }
}
