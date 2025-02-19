// Created by Leopold Lemmermann on 04.02.25.

import Code
import ComposableArchitecture
import Extensions
import Foundation
import Testing
@testable import Transfer

@Suite(.serialized)
@MainActor
struct TransferTest {
  @Test func appear() async throws {
    let content = "Hello, World!"
    let data = content.data(using: .utf8)!
    let file = DataFile(data)
    let store = TestStore(initialState: Transfer.State(), reducer: Transfer.init) { deps in
      deps.code.encode = { _, _ in data }
    }

    await store.send(.file(file)) { $0.file = file}
    await store.receive(\.preview) { $0.preview = content }

    await store.send(.view(.appear))
    await store.receive(\.updateFile)
    await store.receive(\.file) { $0.file = nil }
    await store.receive(\.preview) { $0.preview = nil }
    await store.receive(\.file) { $0.file = file }
    await store.receive(\.preview) { $0.preview = content }
  }

  @Test(.serialized, arguments: Encoding.allCases)
  func selectEncoding(_ encoding: Encoding) async throws {
    let store = TestStore(initialState: Transfer.State(), reducer: Transfer.init) { deps in
      deps.code = .testValue
    }
    store.exhaustivity = .off

    await store.send(.select(encoding))
    store.assert {
      $0.$encoding.withLock { $0 = encoding }
    }
    await store.receive(\.updateFile)
  }

  @Test
  func buttonTaps() async throws {
    let store = TestStore(initialState: Transfer.State(), reducer: Transfer.init) { deps in
      deps.code = .testValue
    }

    await store.send(.view(.importButtonTapped)) {
      $0.importing = true
      $0.exporting = false
    }

    await store.send(.view(.exportButtonTapped)) {
      $0.importing = false
      $0.exporting = true
    }
  }

  @Test
  func importFailure() async throws {
    let store = TestStore(initialState: Transfer.State(), reducer: Transfer.init) { deps in
      deps.code = .testValue
    }

    let no_permission_url = URL(string: "not.a.file.url")!
    await store.send(.view(.import(Result<URL, Error>.success(no_permission_url))))
    await store.receive(\.failure) {
      $0.alert = AlertState { TextState(String(localizable: .noPermission)) }
    }

    let other_error_url = URL.documentsDirectory
    await store.send(.view(.import(Result<URL, Error>.success(other_error_url))))
    await store.receive(\.failure) {
      $0.alert = AlertState { TextState(String(localizable: .error)) }
    }
  }

  @Test
  func importSuccess() async throws {
    let content = "[ 2024-12-31T22:08:53Z, 2024-12-31T22:09:53Z ]"
    let dates = [Date.now, Date().addingTimeInterval(60)]
    let data = content.data(using: .utf8)!
    let url = URL.temporaryDirectory.appendingPathComponent("test.json", conformingTo: .json)
    let result = Result<URL, Error>.success(url)

    let store = TestStore(initialState: Transfer.State(), reducer: Transfer.init) { deps in
      deps.code.decode = { _, _ in .init(dates) }
    }
    store.exhaustivity = .off

    try data.write(to: url)
    #expect(FileManager.default.fileExists(atPath: url.path))
    await store.send(.view(.import(result)))
    store.assert {
      $0.$entries.withLock { $0 = .init(dates) }
    }
    await store.receive(\.file) { $0.file = DataFile(data) }
    await store.receive(\.loadEntries)
    await store.receive(\.preview) { $0.preview = content }
    await store.receive(\.addEntries)
  }

  @Test
  func exportFailure() async throws {
    let store = TestStore(initialState: Transfer.State(), reducer: Transfer.init) { deps in
      deps.code = .testValue
    }
    
    await store.send(.view(.export(Result<URL, Error>.failure(NSError(domain: "", code: 0)))))
    await store.receive(\.failure) {
      $0.alert = AlertState { TextState(String(localizable: .error)) }
    }
  }

  @Test
  func exportSuccess() async throws {
    let content = "[ 2024-12-31T22:08:53Z, 2024-12-31T22:09:53Z ]"
    let url = URL.temporaryDirectory.appendingPathComponent("test.json", conformingTo: .json)
    let result = Result<URL, Error>.success(url)

    let store = TestStore(initialState: Transfer.State(), reducer: Transfer.init) { deps in
      deps.code.encode = { _, _ in content.data(using: .utf8)! }
    }

    await store.send(.view(.export(result)))
  }
}
