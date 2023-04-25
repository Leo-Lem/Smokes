// Created by Leopold Lemmermann on 25.04.23.

import Foundation
import UniformTypeIdentifiers

struct DailyFileCoder: FileCoder {
  static let utType = UTType.json
  
  func encode(_ entries: [Date]) -> Data {
    encodePrepared(prepare(entries))
  }
  
  func decode(_ data: Data) -> [Date] {
    let decoder = JSONDecoder()
    guard let decoded = try? decoder.decode([String: Int].self, from: data) else { return [] }
    
    return decoded.flatMap {
      if let date = formatter.date(from: $0.key) {
        return Array(repeating: date, count: $0.value)
      } else { return [] }
    }
  }
  
  func preview(_ entries: [Date], lines: Int) -> String {
    String(
      data: encodePrepared(Dictionary(uniqueKeysWithValues: Array(prepare(entries).prefix(lines)))),
      encoding: .utf8
    ) ?? ""
  }
  
  private func prepare(_ entries: [Date]) -> [String: Int] {
    Dictionary(uniqueKeysWithValues: groups(entries).map { ($0, amount(entries, group: $0)) })
  }
  
  private func encodePrepared(_ prepared: [String: Int]) -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return (try? encoder.encode(prepared)) ?? Data()
  }
  
  private var formatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }
  
  private func groups(_ entries: [Date]) -> [String] {
    entries.reduce(into: [String]()) { result, next in
      let next = formatter.string(from: next)
      if !result.contains(next) { result.append(next) }
    }
  }
                
  private func amount(_ entries: [Date], group: String) -> Int {
    if
      let last = entries.lastIndex(where: { formatter.string(from: $0) == group }),
      let first = entries.firstIndex(where: { formatter.string(from: $0) == group })
    {
      return last - first + 1
    } else { return 0 }
  }
}
