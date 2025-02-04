// Created by Leopold Lemmermann on 04.02.25.

import class Foundation.Bundle
@_exported import struct Dependencies.Dependency
import Dependencies

public extension DependencyValues {
  var bundle: BundleDependency {
    get { self[BundleDependency.self] }
    set { self[BundleDependency.self] = newValue }
  }
}

public struct BundleDependency: Sendable {
  public var string: @Sendable (_ identifier: String) -> String
}

extension BundleDependency: DependencyKey {
  public static let liveValue = BundleDependency(
    string: { Bundle.main.object(forInfoDictionaryKey: $0) as? String ?? "" }
  )

  public static let previewValue = BundleDependency(string: \.self)
}
