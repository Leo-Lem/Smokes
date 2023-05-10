// Created by Leopold Lemmermann on 10.05.23.

import Foundation

class WrappedHashable<T: Hashable>: NSObject {
  let value: T
  
  init(_ value: T) { self.value = value }
  
  override var hash: Int { value.hashValue }
  
  override func isEqual(_ object: Any?) -> Bool {
    guard let other = object as? WrappedHashable<T> else { return false }
    return self.value == other.value
  }
}

class Wrapped<T>: NSObject {
  let value: T
  init(_ value: T) { self.value = value }
}

