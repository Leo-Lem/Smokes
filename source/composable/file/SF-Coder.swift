// Created by Leopold Lemmermann on 12.03.23.

import Foundation
import UniformTypeIdentifiers

extension SmokesFile {
  struct Coder {
    let contentType: UTType
    
    enum Error: Swift.Error {
      case unsupportedType(UTType)
    }
    
    static var dateFormatter: DateFormatter {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      return formatter
    }
  }
}
  
extension SmokesFile.Coder {
  func decode(_ data: Data) throws -> [Date: Int] {
    switch contentType {
    case .plainText:
      return try decodeList(from: data)
    case .json:
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(Self.dateFormatter)
      return try decoder.decode([Date: Int].self, from: data)
    default:
      throw Error.unsupportedType(contentType)
    }
  }
  
  private func decodeList(from data: Data) throws -> [Date: Int] {
    var amounts = [Date: Int]()
    
    for line in String(data: data, encoding: .utf8)?.split(separator: "\n") ?? [] {
      let comps = line.split(separator: ": ").map(String.init)
      if let date = comps.first.flatMap(Self.dateFormatter.date), let amount = comps.last.flatMap(Int.init) {
        amounts[date + 86399] = amount
      }
    }
    
    return amounts
  }
}

extension SmokesFile.Coder {
  func encode(_ amounts: [Date: Int]) throws -> Data {
    switch contentType {
    case .plainText:
      return encodeToString(amounts).data(using: .utf8) ?? Data()
    case .json:
      let encoder = JSONEncoder()
      encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
      encoder.dateEncodingStrategy = .formatted(Self.dateFormatter)
      return try encoder.encode(amounts)
    default:
      throw Error.unsupportedType(contentType)
    }
  }
  
  private func encodeToString(_ amounts: [Date: Int]) -> String {
    String(amounts.keys
      .sorted()
      .reversed()
      .reduce("") { string, date in "\(string)\(Self.dateFormatter.string(from: date)): \(amounts[date] ?? 0)\n" }
      .dropLast(1)
    )
  }
}
