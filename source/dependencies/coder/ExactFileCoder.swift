// Created by Leopold Lemmermann on 25.04.23.

import Foundation
import UniformTypeIdentifiers

extension Coder where Self == ExactCoder {
  static var exact: Self { ExactCoder() }
}

struct ExactCoder: Coder {
  static let utType = UTType.json
  
  func encode(_ entries: [Date]) -> Data {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = .prettyPrinted
    return (try? encoder.encode(entries.sorted(by: >))) ?? Data()
  }
  
  func decode(_ data: Data) -> [Date] {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return (try? decoder.decode([Date].self, from: data)) ?? []
  }
}
