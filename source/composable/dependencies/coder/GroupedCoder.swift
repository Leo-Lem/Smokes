// Created by Leopold Lemmermann on 25.04.23.

import Dependencies
import Foundation
import UniformTypeIdentifiers

extension Coder where Self == GroupedCoder {
  static var grouped: Self { GroupedCoder() }
}

struct GroupedCoder: Coder {
  static let utType = UTType.json
  
  func encode(_ entries: [Date]) throws -> Data {
    try JSONSerialization.data(withJSONObject: prepare(entries), options: .prettyPrinted)
  }
  
  func decode(_ data: Data) throws -> [Date] {
    guard
      let decoded = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: [String: Int]]]
    else { throw CocoaError(.coderReadCorrupt) }
    return unprepare(decoded)
  }
  
  private func prepare(_ entries: [Date]) -> [String: [String: [String: Int]]] {
    var counts = [String: [String: [String: Int]]]()
          
    for entry in entries {
      let dateString = formatter.string(from: entry)
      let components = dateString.split(separator: " ")
      let year = String(components[0])
      let month = String(components[1])
      let day = String(components[2])
          
      if counts[year] == nil { counts[year] = [:] }
      if counts[year]![month] == nil { counts[year]![month] = [:] }
      counts[year]![month]![day, default: 0] += 1
    }
          
    return counts
  }

  private func unprepare(_ prepared: [String: [String: [String: Int]]]) -> [Date] {
    @Dependency(\.calendar) var cal
    var dates: [Date] = []
          
    prepared.forEach { year, months in
      months.forEach { month, days in
        days.forEach { day, count in
          guard let date = formatter.date(from: "\(year) \(month) \(day)") else { return }
          dates.append(contentsOf: Array(repeating: date, count: count))
        }
      }
    }
          
    return dates.sorted()
  }

  private var formatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy MMMM d"
    return formatter
  }
}
