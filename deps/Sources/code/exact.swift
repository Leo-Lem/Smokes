// Created by Leopold Lemmermann on 25.04.23.

import Foundation

extension Encoding {
  func encode(exact entries: [Date]) throws -> Data {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = .prettyPrinted
    return try encoder.encode(entries.sorted(by: >))
  }
  
  func decode(exact data: Data) throws -> [Date] {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode([Date].self, from: data)
  }
}
