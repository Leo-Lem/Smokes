// Created by Leopold Lemmermann on 23.02.23.

import UniformTypeIdentifiers
import SwiftUI

extension View {
  func attachPorter(imported: Binding<[Date]>, exported: [DateInterval: Int]) -> some View {
    modifier(PorterAttacher(imported: imported, exported: exported))
  }
}

private struct PorterAttacher: ViewModifier {
  @Binding var imported: [Date]
  let exported: [DateInterval: Int]
  
  // FIXME: difference between exported and imported amounts (almost double...)
  func body(content: Content) -> some View {
    content
      .overlay(alignment: .topLeading) {
        HStack {
          Button(systemImage: "square.and.arrow.up") { showingExporter = true }
          Button(systemImage: "square.and.arrow.down") { showingImporter = true }
        }
        .imageScale(.large)
        .font(.headline)
        .padding(5)
      }
      .fileExporter(
        isPresented: $showingExporter,
        document: createDoc(from: exported),
        contentType: .plainText,
        defaultFilename: "SmokesData"
      ) {
        switch $0 {
        case .success(let url): debugPrint(url)
        case .failure(let error): debugPrint(error)
        }
      }
      .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.plainText]) {
        switch $0 {
        case .success(let url): imported = parseFile(at: url)
        case .failure(let error): debugPrint(error)
        }
      }
  }

  @State private var showingExporter = false
  @State private var showingImporter = false
  
  private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }
  
  // TODO: move into reducer
  private func createDoc(from data: [DateInterval: Int]) -> SmokesDoc {
    let filtered = data.filter { $0.value > 0 }
    let sorted = filtered.sorted { $0.key < $1.key }
    let formatted = sorted.map { (key: $0.key, value: $0.value) }
    var text = formatted.reduce("") { $0 + "\(dateFormatter.string(from: $1.key.start)): \($1.value)\n" }
    text = String(text.dropLast())
    
    return SmokesDoc(text)
  }
  
  private func parseFile(at url: URL) -> [Date] {
    var dates = [Date]()
    
    do {
      guard url.startAccessingSecurityScopedResource() else { return [] }
      let raw = try String(contentsOf: url)
      url.stopAccessingSecurityScopedResource()
      
      let lines = raw.split(separator: "\n")
      dates = Array(lines
        .compactMap {
          let comps = $0.split(separator: ": ").map(String.init)
          if let date = comps.first.flatMap(dateFormatter.date), let amount = comps.last.flatMap(Int.init) {
            return Array(repeating: date, count: amount)
          } else { return nil }
        }
        .joined()
      )
    } catch { debugPrint(error) }
    
    return dates
  }
}

struct SmokesDoc: FileDocument {
  static let readableContentTypes = [UTType.plainText]
  
  private var contents = ""
  
  init(_ contents: String) { self.contents = contents }
  init(configuration: ReadConfiguration) throws { contents = "" }
  
  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    FileWrapper(regularFileWithContents: contents.data(using: .utf8) ?? Data())
  }
}
