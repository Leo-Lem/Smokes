// Created by Leopold Lemmermann on 28.04.23.

import ComposableArchitecture
@testable import SmokesReducers
import XCTest

@MainActor
final class FileTests: XCTestCase {
  func test_whenSettingData_thenDecodes() async throws {
    let data = Data()
    
    let store = TestStore(initialState: .init(entries: []), reducer: File())
    
    await store.send(.setData(data)) { $0.data = data }
    await store.receive(/.decode, timeout: 1)
    await store.receive(/.setEntries([], encode: false), timeout: 1)
  }
  
  func test_whenSettingEncoding_thenEncodes() async throws {
    let encoding = EntriesEncoding.exact
    
    let store = TestStore(initialState: .init(entries: []), reducer: File())
    
    await store.send(.setEncoding(encoding)) { $0.encoding = encoding }
    await store.receive(/.encode, timeout: 1)
    await store.receive(/.setData(Data(), encode: false), timeout: 1) { $0.data = Data() }
  }
  
  func test_whenSettingEntries_thenEncodes() async throws {
    let base = Date(timeIntervalSinceReferenceDate: 0)
    let entries = [base - 999_999, base, base + 999_999]
    let encoding = EntriesEncoding.daily
    let data = try encoding.encode(entries)
    
    let store = TestStore(initialState: .init(entries: [], encoding: encoding), reducer: File())
    
    await store.send(.setEntries(.init(entries))) { $0.entries = .init(entries) }
    await store.receive(/.encode, timeout: 1)
    await store.receive(/.setData(data), timeout: 1) { $0.data = data }
  }
}
