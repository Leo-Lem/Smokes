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
      let decoded = try decoder.decode([String: Int].self, from: data)
      return decodeDatesFromStrings(decoded)
    default:
      throw Error.unsupportedType(contentType)
    }
  }
  
  private func decodeList(from data: Data) throws -> [Date: Int] {
    var stringAmounts = [String: Int]()
    
    for line in String(data: data, encoding: .utf8)?.split(separator: "\n") ?? [] {
      let comps = line.split(separator: ": ").map(String.init)
      if let string = comps.first, let amount = comps.last.flatMap(Int.init) { stringAmounts[string] = amount }
    }
    
    return decodeDatesFromStrings(stringAmounts)
  }
  
  private func decodeDatesFromStrings(_ stringAmounts: [String: Int]) -> [Date: Int] {
    Dictionary(uniqueKeysWithValues: stringAmounts.compactMap { (string, amount) in
      Self.dateFormatter.date(from: string).flatMap { ($0 + 1, amount) }
    })
  }
}

extension SmokesFile.Coder {
  func encode(_ amounts: [Date: Int]) throws -> Data {
    switch contentType {
    case .plainText:
      return encodeToString(amounts).data(using: .utf8) ?? Data()
      
    case .json:
      let encoder = JSONEncoder()
      encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
      return try encoder.encode(encodeDatesToStrings(amounts))
    default:
      throw Error.unsupportedType(contentType)
    }
  }
  
  private func encodeDatesToStrings(_ amounts: [Date: Int]) -> [String: Int] {
    Dictionary(uniqueKeysWithValues: amounts.map { (Self.dateFormatter.string(from: $0), $1) })
  }
  
  private func encodeToString(_ amounts: [Date: Int]) -> String {
    String(
      encodeDatesToStrings(amounts)
        .sorted(by: >)
        .reduce("") { "\($0)\($1.key): \($1.value)\n" }
        .dropLast(1)
    )
  }
}
