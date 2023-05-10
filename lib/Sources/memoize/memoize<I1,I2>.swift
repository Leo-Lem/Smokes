// Created by Leopold Lemmermann on 10.05.23.

import Foundation

// NSCache is used here to provide a thread safe cache (contrary to Swift's Dictionary)

public func memoize<I1: Hashable, I2: Hashable, O>(_ function: @escaping (I1, I2) -> O) -> (I1, I2) -> O {
  let cache = NSCache<WrappedHashable<CombineHashable>, Wrapped<O>>()

  return { i1, i2 in
    if let cached = cache.object(forKey: WrappedHashable(CombineHashable(i1, i2))) { return cached.value }

    let result = function(i1, i2)
    cache.setObject(Wrapped(result), forKey: WrappedHashable(CombineHashable(i1, i2)))
    return result
  }
}
