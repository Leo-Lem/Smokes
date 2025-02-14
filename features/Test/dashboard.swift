// Created by Leopold Lemmermann on 09.02.25.

import ComposableArchitecture
import struct Foundation.Date
import Testing

@testable import Dashboard

@MainActor struct DashboardTest {
  @Test
  func adding() async throws {
    let now = Date.now
    let store = TestStore(
      initialState: Dashboard.State(),
      reducer: Dashboard.init
    ) { deps in
      deps.date.now = now
    }
    
    await store.send(.addButtonTapped){
      $0.$entries.withLock { $0.append(now) }
    }
  }
  
  @Test
  func removing() async throws {
    let now = Date.now
    let next = Date(timeIntervalSinceNow: 1)
    let store = TestStore(
      initialState: Dashboard.State(entries: [now, next]),
      reducer: Dashboard.init
    ) { deps in
      deps.calendar = .current
      deps.date.now = next
    }
    
    await store.send(.removeButtonTapped) {
      $0.$entries.withLock { $0 = [now] }
    }
  }
  
  @Test
  func computing() async throws {
    let store = TestStore(
      initialState: Dashboard.State(),
      reducer: Dashboard.init
    ) { deps in
      deps.calendar = .current
      deps.date.now = .distantPast
    }
    
    withDependencies { deps in
      deps.date.now = .distantPast
      deps.calendar = .current
      deps.calculate.amount = { _, _ in 1 }
      deps.calculate.break = { _, _ in 1 }
      deps.calculate.longestBreak = { _, _ in 1 }
    } operation: {
      #expect(store.state.dayAmount == 1)
      #expect(store.state.untilHereAmount == 1)
      #expect(store.state.optionAmount == 1)
      #expect(store.state.optionTime == 1)
    }
  }
}
