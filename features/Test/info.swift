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
      deps.bundle.string = { _ in "expected" }
      deps.openURL = .init { url in
        #expect(url == URL(string: "expected")!)
        return true
      }
    }

    await store.send(action)
  }
}
