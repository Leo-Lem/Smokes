// Created by Leopold Lemmermann on 12.03.23.

import Foundation
import UniformTypeIdentifiers

extension SmokesFile {
  struct Previewer {
    func generatePreview(from amounts: [Date: Int], for type: UTType, lineLimit: Int = 10) -> String {
      guard !amounts.isEmpty else { return "No data" }
      
      let previewAmounts = Dictionary(uniqueKeysWithValues: Array(amounts.prefix(10)))
      var string = ""
      
      switch type {
      case .plainText:
        string = String(
          previewAmounts.keys
            .sorted()
            .reversed()
            .reduce("") { "\($0)\(Coder.dateFormatter.string(from: $1)): \(amounts[$1] ?? 0)\n" }
            .dropLast(1)
        )
      case .json:
        do {
          let json = try JSONSerialization.jsonObject(with: try JSONEncoder().encode(previewAmounts))
          let data = try JSONSerialization.data(withJSONObject: json, options: [.sortedKeys, .prettyPrinted])
          string = String(data: data, encoding: .utf8) ?? ""
        } catch { debugPrint(error) }
      default: break
      }
      
      return trimLines(string, limit: lineLimit)
    }
    
    private func trimLines(_ string: String, limit: Int) -> String {
      let lines = string.split(separator: "\n")
      var trimmed = lines.prefix(limit).joined(separator: "\n")
      if lines.count > limit { trimmed.append("\n...") }
      return trimmed
    }
  }
}
