// Created by Leopold Lemmermann on 29.04.23.

public struct CombineHashable: Hashable {
  public let elements: [AnyHashable]
  
  public init(_ elements: AnyHashable...) { self.elements = elements }
  public init(_ elements: [AnyHashable]) { self.elements = elements }
}
