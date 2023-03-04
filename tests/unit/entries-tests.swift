import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class EntriesTests: XCTestCase {
  func testAdding() async {
    let store = TestStore(initialState: .init(dates: []), reducer: Entries())
    
    let date = Date.now
    await store.send(.add(date)) { $0.dates = [date] }
    await store.send(.add(date)) { $0.dates = [date, date] }
  }
  
  func testRemoving() async {
    let date = Date.now
    let store = TestStore(initialState: .init(dates: [date]), reducer: Entries())
    
    await store.send(.remove(date)) { $0.dates = [] }
  }
  
  func testRemovingWithoutAdding() async {
    let store = TestStore(initialState: .init(dates: []), reducer: Entries())
    
    await store.send(.remove(.now))
  }
}
