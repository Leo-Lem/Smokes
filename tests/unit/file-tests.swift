// Created by Leopold Lemmermann on 26.04.23.

import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class FileTests: XCTestCase {
  func testCreatingFile() async throws {
    let entries = [Date()]
    
    let store = TestStore(initialState: .init(), reducer: File()) {
      $0.calendar = .current
    }
    
    await store.send(.create(entries)) {
      $0.file = .init(Data())
      $0.file = .init($0.coder.encode(entries))
    }
  }

  func testChangingCoder() async throws {
    let entries = [Date.now, .now]
    let oldCoder = GroupedCoder()
    let coder = DailyCoder()
    
    let store = TestStore(
      initialState: .init(file: .init(oldCoder.encode(entries)), coder: oldCoder),
      reducer: File()) {
      $0.calendar = .current
    }
    
    await store.send(.changeCoder(coder)) {
      $0.coder = coder
      $0.file = .init(coder.encode(entries))
    }
  }

  func testImportingFile() async throws {
    let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test").appendingPathExtension("json")
    try Data().write(to: url)
    
    let store = TestStore(initialState: .init(), reducer: File()) {
      $0.calendar = .current
    }
    
    await store.send(.import(url)) {
      $0.file = try .init(at: url)
    }
  }

}
