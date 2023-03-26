// Created by Leopold Lemmermann on 26.03.23.

import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class EntriesTests: XCTestCase {
  func testAddingAndRemoving() async {
    let interval = DateInterval(start: .now, duration: 1)
    
    let store = TestStore(initialState: .init(), reducer: Entries())
    
    await store.send(.add(interval.start)) { $0.unwrapped.append(interval.start) }
    await store.receive(/.updateAmounts(interval.start), timeout: 1)
    
    await store.send(.remove(interval.start)) { $0.unwrapped = [] }
    await store.receive(/.updateAmounts(interval.start), timeout: 1)
  }
  
  func testSavingAndLoading() async {
    let expectation = XCTestExpectation(description: "Reading and writing are triggered")
    expectation.expectedFulfillmentCount = 2
    
    let store = TestStore(initialState: .init(), reducer: Entries()) {
      $0.persistor.writeDates = { _ in expectation.fulfill() }
      $0.persistor.readDates = {
        expectation.fulfill()
        return nil
      }
    }
    
    await store.send(.save)
    await store.send(.load)
    await store.receive(/.set([]), timeout: 1) { $0.unwrapped = [] }
    await store.receive(/.updateAmounts(nil), timeout: 1)
    
    wait(for: [expectation], timeout: 1)
  }
}
