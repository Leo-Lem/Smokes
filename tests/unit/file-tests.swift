// Created by Leopold Lemmermann on 26.04.23.

import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class FileTests: XCTestCase {
  func testSettingEntries() async throws {
    let entries = [Date.now]
    
    let store = TestStore(initialState: .init(), reducer: File()) {
      $0.calendar = .current
    }
    
    await store.send(.setEntries(entries)) { $0.entries = entries }
    await store.receive(/.create, timeout: 1) { $0.file = .init(try store.state.coder.encode(entries)) }
  }

  func testSettingCoder() async throws {
    let entries = [Date.now, .now]
    let oldCoder = GroupedCoder(), newCoder = DailyCoder()
    
    let store = TestStore(
      initialState: .init(coder: oldCoder, entries: entries), reducer: File()) {
      $0.calendar = .current
    }
    
    await store.send(.setCoder(newCoder)) { $0.coder = newCoder }
    await store.receive(/.create, timeout: 1) { $0.file = .init(try newCoder.encode(entries)) }
  }
  
  func testImportingFile() async throws {
    let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("t").appendingPathExtension("json")
    
    let store = TestStore(initialState: .init(), reducer: File()) { $0.calendar = .current }
    
    let data = try store.state.coder.encode([Date.now, .now])
    try data.write(to: url)
    
    await store.send(.import(url)) {
      $0.file = .init(data)
      $0.entries = try store.state.coder.decode(data)
    }
  }

  func testImportingInvalidFile() async throws {
    let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("t2").appendingPathExtension("json")
    
    let store = TestStore(initialState: .init(), reducer: File()) {
      $0.calendar = .current
    }
    
    await store.send(.import(url)) { $0.importError = .invalidFormat }
  }
}
