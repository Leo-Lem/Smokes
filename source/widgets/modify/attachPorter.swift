// Created by Leopold Lemmermann on 23.02.23.

import UniformTypeIdentifiers
import SwiftUI

extension View {
  func attachPorter(_ data: [Date: Int]) -> some View {
    modifier(PorterAttacher(data: data))
  }
}

private struct PorterAttacher: ViewModifier {
  let data: [Date: Int]
  
  func body(content: Content) -> some View {
    content
      .overlay(alignment: .bottomLeading) {
        HStack {
          Button(systemImage: "square.and.arrow.up") { showingExporter = true }
//          Button(systemImage: "square.and.arrow.down") { showingImporter = true }
        }
        .imageScale(.large)
        .font(.headline)
        .padding(5)
      }
      .fileExporter(
        isPresented: $showingExporter,
        document: TextDocument(contents),
        contentType: .plainText,
        defaultFilename: "Smokes Data"
      ) {
        switch $0 {
        case .success(let url): debugPrint(url)
        case .failure(let error): debugPrint(error)
        }
      }
//      .fileImporter(
//        isPresented: $showingImporter,
//        allowedContentTypes: [.plainText]
//      ) {
//        switch $0 {
//        case .success(let url):
//          do {
//            let data = try String(contentsOf: url)
//              .split(separator: ",\n")
//              .compactMap {
//                let keyValue = $0.split(separator: ": ")
//                if let key = keyValue.first, let value = keyValue.last {
//                  let date = try Date(key, strategy: .init(format: ))
//                  return (key: date, value: value)
//                } else { return nil }
//              }
//
//            debugPrint(data)
//          } catch { debugPrint(error) }
//        case .failure(let error):
//          debugPrint(error)
//        }
//      }
  }

  @State private var showingExporter = false
//  @State private var showingImporter = false
  
  private var contents: String {
    let filtered = data.filter { $0.value > 0 }
    let sorted = filtered.sorted { $0.key < $1.key }
    let formatted = sorted.map { (key: $0.key.formatted(date: .numeric, time: .omitted), value: $0.value) }
    
    var text = formatted.reduce("") { $0 + "\($1.key): \($1.value),\n" }
    text.removeLast(2)
    
    return text
  }
}

struct TextDocument: FileDocument {
  static let readableContentTypes = [UTType.plainText]
  
  private var contents = ""
  
  init(_ contents: String) { self.contents = contents }
  init(configuration: ReadConfiguration) throws { contents = "" }
  
  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    FileWrapper(regularFileWithContents: contents.data(using: .utf8) ?? Data())
  }
}

// MARK: - (PREVIEWS)

struct PorterAttacher_Previews: PreviewProvider {
  static var previews: some View {
    AmountWidget(10, description: "Today")
      .attachPorter(
        [
          .now: 140,
          Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!: 70,
          Calendar.current.date(byAdding: .month, value: -1, to: .now)!: 110
        ]
      )
  }
}
