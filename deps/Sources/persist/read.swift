// Created by Leopold Lemmermann on 29.04.23.

import Foundation

extension Persist {
  static func read() async throws -> [Date]? {
    try JSONDecoder()
      .decode([Date].self, from: try Data(contentsOf: getURL()))
  }
}
