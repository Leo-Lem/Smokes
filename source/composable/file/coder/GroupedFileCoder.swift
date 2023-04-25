// Created by Leopold Lemmermann on 25.04.23.

import Foundation
import UniformTypeIdentifiers

// TODO: implement groupind by year, month and day

struct GroupedFileCoder: FileCoder {
  static let utType = UTType.json
  
  func encode(_ entries: [Date]) -> Data {
    encodePrepared(prepare(entries))
  }
  
  func decode(_ data: Data) -> [Date] {
    return []
  }
  
  func preview(_ entries: [Date], lines: Int) -> String {
    String(
      data: encodePrepared(Dictionary(uniqueKeysWithValues: Array(prepare(entries).prefix(lines)))),
      encoding: .utf8
    ) ?? ""
  }
  
  private func prepare(_ entries: [Date]) -> [String: [String: [String: Int]]] {
    return .init()
  }
  
  private func encodePrepared(_ prepared: [String: [String: [String: Int]]]) -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return (try? encoder.encode(prepared)) ?? Data()
  }
}
