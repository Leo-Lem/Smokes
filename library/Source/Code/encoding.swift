// Created by Leopold Lemmermann on 28.04.23.

import Dependencies
import Foundation

public enum Encoding: String, Hashable, CaseIterable, Sendable {
  case daily, grouped, exact

  public func encode(_ entries: [Date]) throws -> Data {
    guard !entries.isEmpty else { return Data() }

    switch self {
    case .daily: return try encode(daily: entries)
    case .grouped: return try encode(grouped: entries)
    case .exact: return try encode(exact: entries)
    }
  }

  public func decode(_ data: Data) throws -> [Date] {
    guard !data.isEmpty else { return [] }

    switch self {
    case .daily: return try decode(daily: data).sorted()
    case .grouped: return try decode(grouped: data).sorted()
    case .exact: return try decode(exact: data).sorted()
    }
  }
}
