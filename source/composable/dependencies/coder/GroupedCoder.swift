// Created by Leopold Lemmermann on 25.04.23.

import Foundation
import UniformTypeIdentifiers

extension Coder where Self == GroupedCoder {
  static var grouped: Self { GroupedCoder() }
}

// TODO: implement grouping by year, month and day

struct GroupedCoder: Coder {
  static let utType = UTType.json
  
  func encode(_ entries: [Date]) -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return (try? encoder.encode(prepare(entries))) ?? Data()
  }
  
  func decode(_ data: Data) -> [Date] {
    return []
  }
  
  private func prepare(_ entries: [Date]) -> [String: [String: [String: Int]]] {
    return .init()
  }
}
