// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI
import UniformTypeIdentifiers

// TODO: add import error and alert

struct Porter: View {
  @EnvironmentObject private var store: StoreOf<App>

  var body: some View {
    WithViewStore(store, observe: \.entries.array) { .entries(.set($0)) } content: { entries in
      VStack {
        Widget {
          displayPreview()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .animation(.default, value: preview)
        .if(let: file) { $0
          .fileExporter(isPresented: $showingExporter, document: $1, contentType: .json, defaultFilename: filename) {
            handleError { [result = $0] in debugPrint(try result.get()) }
          }
          .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.json]) {
            handleError { [result = $0] in
              file = try DataFile(at: try result.get())
              try await entries.send(code.decode(file!.content, encoding))
            }
          }
        }

        Spacer()

        Widget {
          HStack {
            importer(isLoading: file == nil && showingImporter)
            formatPicker()
            exporter(isLoading: file == nil && showingExporter)
          }
        }
        .imageScale(.large)
        .font(.headline)
      }
      .padding(5)
      .labelStyle(.iconOnly)
      .presentationDetents([.medium])
      .presentationBackground(.ultraThinMaterial, legacy: Color("BackgroundColor"))
      .compactDismissButton()
      .animation(.default, value: preview)
      .task { update(entries.state) }
      .task(id: CombineHashable(entries.state, encoding)) { update(entries.state) }
    }
  }

  @AppStorage("porter_encoding") private var encoding: Encoding = .daily

  @State private var showingExporter = false
  @State private var showingImporter = false

  @State private var error: Error?
  @State private var preview: String?
  @State private var file: DataFile?
  
  private let filename = String(localized: "SMOKES_FILENAME")

  @Environment(\.dismiss) private var dismiss
  @Dependency(\.code) private var code
}

private extension Porter {
  func update(_ entries: [Date]) {
    handleError {
      file = nil
      file = DataFile(try await code.encode(entries, encoding))
      preview = file.flatMap { String(data: $0.content, encoding: .utf8) }
    }
  }

  func handleError(_ throwing: @escaping () async throws -> Void) {
    Task {
      do {
        try await throwing()
      } catch {
        // TODO: implement user facing error
        self.error = error
      }
    }
  }
}

extension Porter {
  @ViewBuilder private func exporter(isLoading: Bool) -> some View {
    Button { showingExporter = true } label: { Label("EXPORT", systemImage: "square.and.arrow.up") }
      .accessibilityIdentifier("export-button")
      .if(isLoading) { $0
        .hidden()
        .overlay(content: ProgressView.init)
      }
  }

  @ViewBuilder private func importer(isLoading: Bool) -> some View {
    Button { showingImporter = true } label: { Label("IMPORT", systemImage: "square.and.arrow.down") }
      .accessibilityIdentifier("import-button")
      .if(isLoading) { $0
        .hidden()
        .overlay(content: ProgressView.init)
      }
  }

  @ViewBuilder private func formatPicker() -> some View {
    Picker("", selection: $encoding) {
      ForEach(Encoding.allCases, id: \.self) { encoding in
        Text(LocalizedStringKey(encoding.rawValue))
      }
    }
    .pickerStyle(.segmented)
    .accessibilityElement()
    .accessibilityLabel("PICK_FORMAT")
    .accessibilityValue(LocalizedStringKey(encoding.rawValue))
    .accessibilityIdentifier("format-picker")
  }

  @ViewBuilder private func displayPreview() -> some View {
    if let preview {
      Text(preview).lineLimit(10)
    } else { ProgressView() }
  }
}

extension Encoding: RawRepresentable {
  public init?(rawValue: String) {
    switch rawValue {
    case "DAILY_FORMAT": self = .daily
    case "GROUPED_FORMAT": self = .grouped
    case "EXACT_FORMAT": self = .exact
    default: return nil
    }
  }

  public var rawValue: String {
    switch self {
    case .daily: return "DAILY_FORMAT"
    case .grouped: return "GROUPED_FORMAT"
    case .exact: return "EXACT_FORMAT"
    }
  }
}

// MARK: - (PREVIEWS)

struct Porter_Previews: PreviewProvider {
  static var previews: some View {
    Porter().previewInSheet()
      .environmentObject(Store(initialState: .init(), reducer: App()))
  }
}
