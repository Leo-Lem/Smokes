// Created by Leopold Lemmermann on 29.04.23.

public func memoize<I: Hashable, O>(_ function: @escaping (I) -> O) -> (I) -> O {
  var storage = [I: O]()

  return {
    if let cached = storage[$0] { return cached }

    let result = function($0)
    storage[$0] = result
    return result
  }
}

public func memoize<I1: Hashable, I2: Hashable, O>(_ function: @escaping (I1, I2) -> O) -> (I1, I2) -> O {
  var storage = [CombineHashable: O]()

  return { i1, i2 in
    if let cached = storage[CombineHashable(i1, i2)] { return cached }

    let result = function(i1, i2)
    storage[CombineHashable(i1, i2)] = result
    return result
  }
}

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
