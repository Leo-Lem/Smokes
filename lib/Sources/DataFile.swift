// Created by Leopold Lemmermann on 05.03.23.

import struct Foundation.Data
import struct Foundation.URL
import struct Foundation.URLError
import protocol SwiftUI.FileDocument
import class SwiftUI.FileWrapper
import struct UniformTypeIdentifiers.UTType

public struct DataFile: FileDocument, Equatable {
  public static var readableContentTypes = [UTType.json]
  public static var writableContentTypes = [UTType.json]
  
  public let content: Data
  
  public init(_ data: Data) { content = data }
  
  public init(at url: URL) throws {
    if url.startAccessingSecurityScopedResource() {
      defer { url.stopAccessingSecurityScopedResource() }
      content = try Data(contentsOf: url)
    } else {
      throw URLError(.noPermissionsToReadFile)
    }
  }
  
  public init(configuration: ReadConfiguration) throws {
    guard let data = configuration.file.regularFileContents else { throw URLError(.resourceUnavailable) }
    content = data
  }
  
  public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    FileWrapper(regularFileWithContents: content)
  }
}
