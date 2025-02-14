// Created by Leopold Lemmermann on 09.02.25.

import ComposableArchitecture
import struct Foundation.URL
import Testing

@testable import Info

@MainActor
struct InfoTest {
  @Test(arguments: [Info.Action.openSupport, .openPrivacy, .openMarketing])
  func testOpening(_ action: Info.Action) async throws {
    let store = TestStore(initialState: Info.State(), reducer: Info.init) { deps in
      deps.openURL = .init { _ in
        #expect(true)
        return true
      }
    }

    await store.send(action)
  }
}
