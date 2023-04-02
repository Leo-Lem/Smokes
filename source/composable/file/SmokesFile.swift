// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI
import UniformTypeIdentifiers

struct SmokesFile: FileDocument, Equatable {
  static let readableContentTypes = [UTType.plainText, .json]
  static let writableContentTypes = [UTType.plainText, .json]
  
  var amounts = [Date: Int]()
  
  init(_ amounts: [Date: Int]) { self.amounts = amounts }
  
  init(at url: URL) throws {
    guard let type = UTType(filenameExtension: url.pathExtension) else { throw URLError(.cannotDecodeContentData) }
    amounts = try Coder(contentType: type).decode(try Data(contentsOf: url))
  }
  
  init(configuration: ReadConfiguration) throws {
    guard let data = configuration.file.regularFileContents else { throw URLError(.resourceUnavailable) }
    
    do {
      amounts = try Coder(contentType: configuration.contentType).decode(data)
    } catch {
      debugPrint(error)
    }
  }
  
  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    do {
      let data = try Coder(contentType: configuration.contentType).encode(amounts)
      return FileWrapper(regularFileWithContents: data)
    } catch {
      debugPrint(error)
    }
    
    return FileWrapper(regularFileWithContents: Data())
  }
  
  func generatePreview(for type: UTType) -> String {
    guard !amounts.isEmpty else { return "No data" }
    
    let previewData = (try? Coder(contentType: type).encode(
      Dictionary(uniqueKeysWithValues: Array(amounts.sorted(by: >).prefix(8)))
    ))
    
    let preview = previewData.flatMap { String(data: $0, encoding: .utf8) } ?? "No data"
    
    return trimLines(preview, limit: 10)
  }
  
  private func trimLines(_ string: String, limit: Int) -> String {
    let lines = string.split(separator: "\n")
    var trimmed = lines.prefix(limit).joined(separator: "\n")
    if lines.count > limit { trimmed.append("\n...") }
    return trimmed
  }
}
