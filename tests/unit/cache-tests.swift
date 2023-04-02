// Created by Leopold Lemmermann on 02.04.23.

import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class CacheTests: XCTestCase {
  func testLoading() async throws {
    let interval = Interval.day(.now)
    
    let store = TestStore(initialState: .init(), reducer: Cache()) {
      $0.calculator.amount = { _, _ in 1 }
      $0.calendar = .current
    }
    
    await store.send(.load([], interval: interval)) { $0.amounts[interval] = 1 }
  }
  
  func testLoadingAll() async throws {
    let interval = Interval.week(.now), subdivision = Subdivision.day
    
    let store = TestStore(initialState: .init(), reducer: Cache()) {
      $0.calculator.amount = { _, _ in 1 }
      $0.calendar = .current
    }
    
    await store.send(.loadAll([], interval: interval, subdivision: subdivision))
    for interval in interval.enumerate(by: subdivision) ?? [] {
      await store.receive(/.load([], interval: interval), timeout: 1) { $0.amounts[interval] = 1 }
    }
  }
  
  func testReloadingWithoutDate() async throws {
    let store = TestStore(initialState: .init(amounts: [.alltime: 0]), reducer: Cache()) {
      $0.calculator.amount = { _, _ in 1 }
      $0.calendar = .current
    }
    
    await store.send(.reload([]))
    await store.receive(/.load([], interval: .alltime), timeout: 1) { $0.amounts[.alltime] = 1 }
  }
  
  func testReloadingWithDate() async throws {
    let now = Date.now
    let interval = Interval.day(now)
    
    let store = TestStore(initialState: .init(amounts: [interval: 0]), reducer: Cache()) {
      $0.calculator.amount = { _, _ in 1 }
      $0.calendar = .current
    }
    
    await store.send(.reload([], date: now))
    await store.receive(/.load([], interval: interval), timeout: 1) { $0.amounts[interval] = 1 }
  }
}
