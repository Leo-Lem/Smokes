// Created by Leopold Lemmermann on 29.04.23.

import Foundation

@MainActor
public func memoize<I1: Hashable, I2: Hashable, I3: Hashable, O>(
  _ function: @escaping (I1, I2, I3) -> O
) -> (I1, I2, I3) -> O {
  var storage = [CombineHashable: O]()

  return {
    let hashable = CombineHashable($0, $1, $2)
    if let cached = storage[hashable] { return cached }

    let result = function($0, $1, $2)
    storage[hashable] = result
    return result
  }
}

@MainActor
public func memoize<I1: Hashable, I2: Hashable, I3: Hashable, O>(
  _ function: @escaping (I1, I2, I3) async -> O
) -> (I1, I2, I3) async -> O {
  var storage = [CombineHashable: O]()

  return {
    let hashable = CombineHashable($0, $1, $2)
    if let cached = storage[hashable] { return cached }

    let result = await function($0, $1, $2)
    storage[hashable] = result
    return result
  }
}
