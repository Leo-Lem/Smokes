// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI
import UniformTypeIdentifiers

struct DataFile: FileDocument, Equatable {
  static var readableContentTypes = [UTType.json]
  static var writableContentTypes = [UTType.json]
  
  let content: Data
  
  init(_ data: Data) { content = data }
  
  init(at url: URL) throws {
    if url.startAccessingSecurityScopedResource() {
      defer { url.stopAccessingSecurityScopedResource() }
      content = try Data(contentsOf: url)
    } else {
      throw URLError(.noPermissionsToReadFile)
    }
  }
  
  init(configuration: ReadConfiguration) throws {
    guard let data = configuration.file.regularFileContents else { throw URLError(.resourceUnavailable) }
    content = data
  }
  
  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    FileWrapper(regularFileWithContents: content)
  }
}
