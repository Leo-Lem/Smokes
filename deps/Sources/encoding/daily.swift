// Created by Leopold Lemmermann on 25.04.23.

import Foundation

extension EntriesEncoding {
  func encode(daily entries: [Date]) throws -> Data {
    try JSONSerialization.data(withJSONObject: prepare(entries), options: [.sortedKeys, .prettyPrinted])
  }
  
  func decode(daily data: Data) throws -> [Date] {
    guard let decoded = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Int] else {
      throw CocoaError(.coderReadCorrupt)
    }
    return unprepare(decoded)
  }
  
  private func prepare(_ entries: [Date]) -> [String: Int] {
    entries.reduce(into: [String: Int]()) { counts, entry in
      let key = formatter.string(from: entry)
      counts[key, default: 0] += 1
    }
  }
  
  private func unprepare(_ prepared: [String: Int]) -> [Date] {
    prepared
      .compactMap { entry in formatter.date(from: entry.key).flatMap { (key: $0, value: entry.value) } }
      .sorted { entry1, entry2 in entry1.key > entry2.key }
      .flatMap { Array(repeating: $0.key, count: $0.value) }
  }
  
  private var formatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }
}
