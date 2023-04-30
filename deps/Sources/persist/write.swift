// Created by Leopold Lemmermann on 29.04.23.

import Foundation

extension Persist {
  static func write(_ dates: [Date]) async throws {
    try JSONEncoder()
      .encode(dates)
      .write(to: try getURL())
  }
}
