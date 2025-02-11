// Created by Leopold Lemmermann on 09.02.25.

import ComposableArchitecture
import Testing

@testable import App

@MainActor struct AppTest {
  @Test func info() async throws {
    let store = TestStore(initialState: Smokes.State(), reducer: Smokes.init) { deps in
      deps.date.now = .now
    }

    await store.send(.infoButtonTapped) {
      $0.info = .init()
    }
  }

  @Test func fact() async throws {
    let store = TestStore(initialState: Smokes.State(), reducer: Smokes.init) { deps in
      deps.date.now = .now
    }

    await store.send(.factButtonTapped) {
      $0.fact = .init()
    }
  }

  @Test func transfer() async throws {
    let store = TestStore(initialState: Smokes.State(), reducer: Smokes.init) { deps in
      deps.date.now = .now
    }

    await store.send(\.dashboard.binding.transferring, true) {
      $0.$transferring.withLock { $0 = true }
      $0.transfer = .init()
    }
  }
}
