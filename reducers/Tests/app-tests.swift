// Created by Leopold Lemmermann on 28.04.23.

import ComposableArchitecture
@testable import SmokesReducers
import XCTest

@MainActor
final class AppTests: XCTestCase {
  func test_whenLoadingEntries_thenSetsEntries() async throws {
    let base = Date(timeIntervalSinceReferenceDate: 0)
    let dates = [base - 999_999, base, base + 999_999]
    
    let store = TestStore(initialState: .init(), reducer: App()) {
      $0.persistor.readDates = { dates }
    }
    
    store.exhaustivity = .off
    
    await store.send(.loadEntries)
    await store.receive(/.entries(.set(.init(dates))), timeout: 1) { $0.entries = .init(dates) }
    await store.receive(/.calculate(.setEntries(.init(dates))), timeout: 1) { $0.calculate.entries = .init(dates) }
    await store.receive(/.file(.setEntries(.init(dates))), timeout: 1) { $0.file.entries = .init(dates) }
  }
  
  func test_whenFailingToLoadEntries_thenSetsToEmpty() async throws {
    let store = TestStore(initialState: .init([.now]), reducer: App()) {
      $0.persistor.readDates = { throw URLError(.badURL) }
    }
    
    store.exhaustivity = .off
    
    await store.send(.loadEntries)
    await store.receive(/.entries(.set([])), timeout: 1) { $0.entries = [] }
    await store.receive(/.calculate(.setEntries([])), timeout: 1) { $0.calculate.entries = [] }
    await store.receive(/.file(.setEntries([])), timeout: 1) { $0.file.entries = []}
  }
  
  func test_whenSavingEntries_thenTriggersSave() async throws {
    let expectation = XCTestExpectation(description: "correct dates are saved")
    
    let base = Date(timeIntervalSinceReferenceDate: 0)
    let dates = [base - 999_999, base, base + 999_999]
    
    let store = TestStore(initialState: .init(.init(dates)), reducer: App()) {
      $0.persistor.writeDates = {
        if $0 == dates { expectation.fulfill() }
      }
    }
    
    await store.send(.saveEntries)
    
    await fulfillment(of: [expectation], timeout: 1)
  }
}
