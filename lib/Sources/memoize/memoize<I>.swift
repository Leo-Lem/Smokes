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

public func memoizeThreadSafe<I: Hashable, O>(_ function: @escaping (I) -> O) -> (I) -> O {
  let cache = NSCache<WrappedHashable<I>, Wrapped<O>>()

  return {
    if let cached = cache.object(forKey: WrappedHashable($0)) { return cached.value }

    let result = function($0)
    cache.setObject(Wrapped(result), forKey: WrappedHashable($0))
    return result
  }
}
