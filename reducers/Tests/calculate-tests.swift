// Created by Leopold Lemmermann on 28.04.23.

import XCTest
@testable import SmokesReducers
import ComposableArchitecture

@MainActor
final class CalculateTests: XCTestCase {
  func test_whenCalculating_thenAddsToCache() async throws {
    let data = 2
    
    let store = TestStore(initialState: .init(data), reducer: Calculate<Int, Int, Int>({ $0 + $1 }))
    
    let i = 1
    
    await store.send(.calculate(1))
    await store.receive(/.setResult(data + i, for: i)) { $0.cache[i] = data + i }
  }
}
