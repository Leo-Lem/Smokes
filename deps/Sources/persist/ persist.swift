// Created by Leopold Lemmermann on 23.02.23.

import Foundation
import Dependencies

public extension DependencyValues {
  var persist: Persist {
    get { self[Persist.self] }
    set { self[Persist.self] = newValue }
  }
}

public struct Persist {
  public var write: ([Date]) async throws -> Void
  public var read: () async throws -> [Date]?
}

extension Persist: DependencyKey {
  public static var liveValue = Self(
    write: Self.write,
    read: Self.read
  )
  
  #if DEBUG
  public static let previewValue = Self(
    write: { _ in },
    read: { (0..<1000).map { _ in Date(timeIntervalSinceNow: -Double.random(in: 0..<9_999_999)) } }
  )
  #endif
}

extension Persist {
  static let filename = "entries.json"
  
  static func getURL() throws -> URL {
    try FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      .appending(component: filename)
      .appendingPathExtension(for: .json)
  }
}
