// Created by Leopold Lemmermann on 26.03.23.

import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class EntriesTests: XCTestCase {
  func testAdding() async throws {
    let now = Date.now
    
    let store = TestStore(initialState: .init(), reducer: Entries())
    
    await store.send(.add(now)) { $0.entries = [now] }
    await store.send(.add(now+1)) { $0.entries = [now, now+1] }
  }
  
  func testRemoving() async throws {
    let now = Date.now
    
    let store = TestStore(initialState: .init(entries: [now]), reducer: Entries()) { $0.calendar = .current }
    
    await store.send(.remove(now)) { $0.entries = [] }
  }
  
  func testRemovingEmpty() async throws {
    let now = Date.now
    
    let store = TestStore(initialState: .init(), reducer: Entries())
    
    await store.send(.remove(now))
  }
  
  func testLoading() async throws {
    let now = Date.now
    
    let store = TestStore(initialState: .init(), reducer: Entries()) { $0.persistor.readDates = { [now] } }
    
    await store.send(.load)
    await store.receive(/.set([now]), timeout: 1) { $0.entries = [now] }
    await store.receive(/.setAreLoaded, timeout: 1) { $0.areLoaded = true }
  }
  
  func testLoadingNothing() async throws {
    let store = TestStore(initialState: .init(), reducer: Entries()) { $0.persistor.readDates = { nil } }
    
    await store.send(.load)
    await store.receive(/.setAreLoaded, timeout: 1) { $0.areLoaded = true }
  }
  
  func testLoadingFails() async throws {
    let store = TestStore(initialState: .init(), reducer: Entries()) {
      $0.persistor.readDates = { throw URLError(.badURL) }
    }
    
    await store.send(.load)
    await store.receive(/.setAreLoaded, timeout: 1) { $0.areLoaded = true }
  }
  
  func testSaving() async throws {
    let now = Date.now
    
    var storage = [Date]()
    
    let store = TestStore(initialState: .init(entries: [now]), reducer: Entries()) {
      $0.persistor.writeDates = { storage = $0 }
    }
    
    await store.send(.save)
    XCTAssertEqual(storage, [now])
  }
  
  func testSavingFails() async throws {
    let store = TestStore(initialState: .init(), reducer: Entries()) {
      $0.persistor.writeDates = { _ in throw URLError(.cancelled) }
    }
    
    await store.send(.save)
  }
  
  func testStartDate() async throws {
    let now = Date.now
    
    withDependencies {
      $0.calendar = .current
      $0.date.now = now
    } operation: {
      let store = TestStore(initialState: .init(entries: [now, now+1]), reducer: Entries())
      
      XCTAssertEqual(store.state.startDate, .startOfToday)
    }
  }
  
  func testEmptyStartDate() async throws {
    let now = Date.now
    
    withDependencies {
      $0.calendar = .current
      $0.date.now = now
    } operation: {
      let store = TestStore(initialState: .init(), reducer: Entries()) {
        $0.calendar = .current
        $0.date = .constant(now)
      }
      
      XCTAssertEqual(store.state.startDate, .startOfToday)
    }
  }
}
