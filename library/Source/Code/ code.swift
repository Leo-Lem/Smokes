// Created by Leopold Lemmermann on 29.04.23.

import Dependencies
import Foundation

public extension DependencyValues {
  var code: Code {
    get { self[Code.self] }
    set { self[Code.self] = newValue }
  }
}

public struct Code: Sendable {
  public var encode: @Sendable ([Date], Encoding) async throws -> Data
  public var decode: @Sendable (Data, Encoding) async throws -> [Date]
}

extension Code: DependencyKey {
  public static let liveValue = Code(
    encode: { try $1.encode($0) },
    decode: { try $1.decode($0) }
  )

  #if DEBUG
  public static let previewValue = Code(
    encode: { _, _ in Data() },
    decode: { _, _ in [] }
  )
  #endif
}
