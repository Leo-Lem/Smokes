// Created by Leopold Lemmermann on 09.02.25.

import ComposableArchitecture
import struct Foundation.Date
import Testing

@testable import History

@MainActor
struct HistoryTest {
  @Test
  func adding() async throws {
    let now = Date.now
    let store = TestStore(
      initialState: History.State(selection: now),
      reducer: History.init
    )

    await store.send(.addButtonTapped){
      $0.$entries.withLock { $0.append(now) }
    }
  }

  @Test
  func removing() async throws {
    let now = Date.now
    let next = Date(timeIntervalSinceNow: 1)
    let store = TestStore(
      initialState: History.State(entries: [now, next], selection: next),
      reducer: History.init
    ) { deps in
      deps.calendar = .current
    }

    await store.send(.removeButtonTapped) {
      $0.$entries.withLock { $0 = [now] }
    }
  }

  @Test
  func computing() async throws {
    let store = TestStore(
      initialState: History.State(),
      reducer: History.init
    ) { deps in
      deps.calendar = .current
      deps.date.now = .distantPast
    }

    withDependencies { deps in
      deps.date.now = .distantPast
      deps.calendar = .current
      deps.calculate.amount = { _, _ in 1 }
      deps.calculate.amounts = { _, _, _ in [.alltime: 1] }
    } operation: {
      #expect(store.state.dayAmount == 1)
      #expect(store.state.untilHereAmount == 1)
      #expect(store.state.optionAmount == 1)
      #expect(store.state.plotData == [.alltime: 1])
      #expect(store.state.bounds.contains(.distantPast))
    }
  }
}
