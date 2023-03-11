// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI
import UniformTypeIdentifiers

struct SmokesFile: FileDocument, Equatable {
  static let readableContentTypes: [UTType] = [.plainText, .json]
  
  var amounts = [Date: Int](), format: UTType
  
  init(configuration: ReadConfiguration) throws {
    guard let data = configuration.file.regularFileContents else { throw URLError(.resourceUnavailable) }
    format = configuration.contentType
    try decode(data)
  }
  
  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    FileWrapper(regularFileWithContents: try encode())
  }
}

// MARK: initializers

extension SmokesFile {
  init(at url: URL) throws {
    guard let format = UTType(filenameExtension: url.pathExtension), Self.readableContentTypes.contains(format) else {
      throw URLError(.cannotDecodeContentData)
    }
    self.format = format
    try decode(try Data(contentsOf: url))
  }
  
  init(_ amounts: [Date: Int], format: UTType) throws { (self.amounts, self.format) = (amounts, format) }
}

// MARK: preview

extension SmokesFile {
  var preview: String {
    guard !amounts.isEmpty else { return "No data" }
    
    var string = ""
    
    switch format {
    case .plainText:
      string = CustomListCoder().encodeToString(amounts)
    case .json:
      do {
        let json = try JSONSerialization.jsonObject(with: try encode())
        let data = try JSONSerialization.data(withJSONObject: json, options: [.sortedKeys, .prettyPrinted])
        string = String(data: data, encoding: .utf8) ?? ""
      } catch { debugPrint(error) }
    default: break
    }
    
    let lines = string.split(separator: "\n")
    string = lines.prefix(9).joined(separator: "\n")
    if lines.count > 9 { string.append("\n...") }
    return string
  }
  
  private func encode() throws -> Data {
    switch format {
    case .plainText: return try CustomListCoder().encode(amounts)
    case .json:
      let encoder = JSONEncoder()
      encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
      encoder.dateEncodingStrategy = .formatted(CustomListCoder.dateFormatter)
      return try encoder.encode(amounts)
    default: throw CocoaError(.fileWriteUnsupportedScheme)
    }
  }
  
  private mutating func decode(_ data: Data) throws {
    switch format {
    case .plainText: amounts = try CustomListCoder().decode(from: data)
    case .json:
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(CustomListCoder.dateFormatter)
      amounts = try decoder.decode([Date: Int].self, from: data)
    default: throw CocoaError(.fileReadUnsupportedScheme)
    }
  }
}

// MARK: CustomListCoder

extension SmokesFile {
  struct CustomListCoder {
    func encode(_ amounts: [Date: Int]) throws -> Data { encodeToString(amounts).data(using: .utf8)! }
    
    func decode(from data: Data) throws -> [Date: Int] {
      var amounts = [Date: Int]()
      
      for line in try decodeToString(data).split(separator: "\n") {
        let comps = line.split(separator: ": ").map(String.init)
        if let date = comps.first.flatMap(Self.dateFormatter.date), let amount = comps.last.flatMap(Int.init) {
          amounts[date + 86399] = amount
        }
      }
      
      return amounts
    }
    
    func encodeToString(_ amounts: [Date: Int]) -> String {
      var string = ""
      for date in amounts.keys.sorted().reversed() {
        string.append("\(Self.dateFormatter.string(from: date)): \(amounts[date]!)\n")
      }
      return String(string.dropLast())
    }
    
    func decodeToString(_ data: Data) throws -> String {
      guard let string = String(data: data, encoding: .utf8) else { throw URLError(.cannotDecodeRawData) }
      return string
    }
    
    static var dateFormatter: DateFormatter {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      return formatter
    }
  }
}
