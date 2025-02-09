// Created by Leopold Lemmermann on 03.02.25.

import ComposableArchitecture
import Dependencies
import class Foundation.URLSession
import Testing

@testable import Fact

struct FactTest {
  let clock = TestClock()

  @Test func testCountdown() async throws {
    let store = await TestStore(initialState: Fact.State(), reducer: Fact.init) {
      $0.continuousClock = clock
      $0.dismiss = .init { #expect(true) }
    }

    await store.send(.countdown) { $0.countdown -= 50 }

    while await store.state.countdown >= 0 {
      await clock.advance(by: .milliseconds(50))
      await store.receive(\.countdown) { $0.countdown -= 50 }
    }

    await store.receive(\.dismiss)
  }
}

