// Created by Leopold Lemmermann on 10.05.23.

import Foundation

@MainActor
public func memoize<I: Hashable, O>(_ function: @escaping (I) -> O) -> (I) -> O {
  var storage = [I: O]()

  return {
    if let cached = storage[$0] { return cached }

    let result = function($0)
    storage[$0] = result
    return result
  }
}

@MainActor
public func memoize<I: Hashable, O>(_ function: @escaping (I) async -> O) -> (I) async -> O {
  var storage = [I: O]()

  return {
    if let cached = storage[$0] { return cached }

    let result = await function($0)
    storage[$0] = result
    return result
  }
}
