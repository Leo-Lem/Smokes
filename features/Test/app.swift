// Created by Leopold Lemmermann on 09.02.25.

import ComposableArchitecture
import Testing

@testable import App

@MainActor struct AppTest {
  @Test func info() async throws {
    let store = TestStore(initialState: Smokes.State(), reducer: Smokes.init) { deps in
      deps.date.now = .now
    }

    await store.send(.view(.infoButtonTapped)) {
      $0.info = .init()
    }
  }

  @Test func fact() async throws {
    let store = TestStore(initialState: Smokes.State(), reducer: Smokes.init) { deps in
      deps.date.now = .now
    }

    await store.send(.view(.factButtonTapped)) {
      $0.fact = .init()
    }
  }

  @Test func transfer() async throws {
    let store = TestStore(initialState: Smokes.State(), reducer: Smokes.init) { deps in
      deps.date.now = .now
    }

    await store.send(.view(.transferButtonTapped)) {
      $0.transfer = .init()
    }
  }
}
