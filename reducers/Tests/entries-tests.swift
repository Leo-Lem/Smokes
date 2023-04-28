// Created by Leopold Lemmermann on 28.04.23.

import XCTest
@testable import SmokesReducers
import ComposableArchitecture

@MainActor
final class EntriesTests: XCTestCase {
  func test_whenAddingDate_thenAddsToEntries() async throws {
    let base = Date(timeIntervalSinceReferenceDate: 0)
    let dates = [base - 999_999, base, base + 999_999]
    
    let store = TestStore(initialState: [], reducer: Entries())
    
    for date in dates {
      await store.send(.add(date)) { $0.append(date) }
      await store.receive(/.change, timeout: 1)
    }
  }
  
  func test_whenRemovingDate_thenRemovesFromEntries() async throws {
    let base = Date(timeIntervalSinceReferenceDate: 0)
    let dates = [base - 999_999, base, base + 999_999]
    
    let store = TestStore(initialState: .init(dates), reducer: Entries()) { $0.calendar = .current }
    
    for date in dates {
      await store.send(.remove(date)) { $0.removeFirst() }
      await store.receive(/.change, timeout: 1)
    }
    
  }
  
  func test_givenEntriesAreEmpty_whenRemovingDate_thenNoChange() async throws {
    let base = Date(timeIntervalSinceReferenceDate: 0)
    let dates = [base - 999_999, base, base + 999_999]
    
    let store = TestStore(initialState: [], reducer: Entries())
    
    for date in dates {
      await store.send(.remove(date))
      await store.receive(/.change, timeout: 1)
    }
  }
}
