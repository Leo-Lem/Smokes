// Created by Leopold Lemmermann on 25.04.23.

import Foundation
import UniformTypeIdentifiers

struct ExactFileCoder: FileCoder {
  static let utType = UTType.json
  
  func encode(_ entries: [Date]) -> Data {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = .prettyPrinted
    return (try? encoder.encode(prepare(entries))) ?? Data()
  }
  
  func decode(_ data: Data) -> [Date] {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return (try? decoder.decode([Date].self, from: data)) ?? []
  }
  
  func preview(_ entries: [Date], lines: Int) -> String {
    let encoded = encode(Array(entries.prefix(lines)))
    return String(data: encoded, encoding: .utf8) ?? ""
  }
  
  private func prepare(_ entries: [Date]) -> [Date] {
    entries.sorted(by: >)
  }
}
