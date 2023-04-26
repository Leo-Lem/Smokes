// Created by Leopold Lemmermann on 25.04.23.

import Foundation
import UniformTypeIdentifiers

extension Coder where Self == DailyCoder {
  static var daily: Self { DailyCoder() }
}

struct DailyCoder: Coder {
  static let utType = UTType.json
  
  func encode(_ entries: [Date]) -> Data {
    (try? JSONSerialization.data(withJSONObject: prepare(entries), options: .prettyPrinted)) ?? Data()
  }
  
  private let decoder = JSONDecoder()
  func decode(_ data: Data) -> [Date] {
    guard let decoded = try? decoder.decode([String: Int].self, from: data) else { return [] }
    
    let entries = decoded
      .compactMap { entry in formatter.date(from: entry.key).flatMap { (key: $0, value: entry.value) } }
      .sorted { entry1, entry2 in entry1.key > entry2.key }
      .flatMap { Array(repeating: $0.key, count: $0.value) }
    
    return entries
  }
  
  private func prepare(_ entries: [Date]) -> [String: Int] {
    entries.reduce(into: [String: Int]()) { counts, entry in
      let key = formatter.string(from: entry)
      counts[key, default: 0] += 1
    }
  }
  
  private var formatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }
}
