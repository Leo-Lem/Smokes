// Created by Leopold Lemmermann on 29.04.23.

public struct CombinedHashable<T1: Hashable, T2: Hashable>: Hashable {
  public let first: T1, second: T2
  
  public init(_ first: T1, _ second: T2) {
    self.first = first
    self.second = second
  }
}
