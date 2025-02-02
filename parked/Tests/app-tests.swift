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
      $0.persist.read = { dates }
    }
    
    await store.send(.loadEntries)
    await store.receive(/.entries(.set(.init(dates))), timeout: .seconds(1)) { $0.entries = .init(dates) }
  }
  
  func test_whenFailingToLoadEntries_thenSetsToEmpty() async throws {
    let store = TestStore(initialState: .init([.now]), reducer: App()) {
      $0.persist.read = { throw URLError(.badURL) }
    }
    
    await store.send(.loadEntries)
    await store.receive(/.entries(.set([])), timeout: .seconds(1)) { $0.entries = [] }
  }
  
  func test_whenSavingEntries_thenTriggersSave() async throws {
    let expectation = XCTestExpectation(description: "correct dates are saved")
    
    let base = Date(timeIntervalSinceReferenceDate: 0)
    let dates = [base - 999_999, base, base + 999_999]
    
    let store = TestStore(initialState: .init(.init(dates)), reducer: App()) {
      $0.persist.write = { if $0 == dates { expectation.fulfill() } }
    }
    
    await store.send(.saveEntries)
    
    await fulfillment(of: [expectation], timeout: 1)
  }
}
