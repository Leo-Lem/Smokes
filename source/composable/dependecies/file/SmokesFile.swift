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
    amounts = try Coder(contentType: configuration.contentType).decode(data)
  }
  
  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    let data = try Coder(contentType: configuration.contentType).encode(amounts)
    return FileWrapper(regularFileWithContents: data)
  }
  
  func generatePreview(for type: UTType) -> String { Previewer().generatePreview(from: amounts, for: type) }
}
