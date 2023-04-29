// Created by Leopold Lemmermann on 29.04.23.

import Dependencies
import Foundation

public extension DependencyValues {
  var code: Code {
    get { self[Code.self] }
    set { self[Code.self] = newValue }
  }
}

public struct Code {
  public var encode: ([Date], Encoding) throws -> Data
  public var decode: (Data, Encoding) throws -> [Date]
}

extension Code: DependencyKey {
  public static var liveValue = Code(
    encode: { try $1.encode($0) },
    decode: { try $1.decode($0) }
  )
  
  #if DEBUG
  public static var previewValue = Code(
    encode: { _, _ in Data() },
    decode: { _, _ in [] }
  )
  #endif
}
