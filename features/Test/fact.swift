// Created by Leopold Lemmermann on 03.02.25.

import ComposableArchitecture
import class Foundation.URLSession
import Testing

@testable import Fact

@MainActor
struct FactTest {
  @Test
  func appear() async throws {
    let store = TestStore(initialState: Fact.State(), reducer: Fact.init) { deps in
      deps.continuousClock = ImmediateClock()
      deps.bundle.string = { _ in "http://nothing.to.see.here" }
      deps.urlSession = URLSession(configuration: .ephemeral)
    }
    store.exhaustivity = .off

    await store.send(.appear)
    await store.receive(\.fetch)

    // TODO: create fact api client dependency

    await store.finish()
  }

  @Test
  func countdown() async throws {
    let clock = TestClock()
    let store = TestStore(initialState: Fact.State(), reducer: Fact.init) { deps in
      deps.continuousClock = clock
      deps.dismiss = .init { #expect(true) }
    }

    await store.send(.countdown) { $0.progress += 0.01 }

    while store.state.progress <= 0.99 {
      await clock.advance(by: .milliseconds(50))
      await store.receive(\.countdown) { $0.progress += 0.01 }
    }

    await store.receive(\.dismiss)
  }
}
