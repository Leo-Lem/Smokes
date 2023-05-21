// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI
import LeosMisc

struct Porter: View {
  @EnvironmentObject private var store: StoreOf<App>

  var body: some View {
    WithViewStore(store, observe: \.entries.array) { .entries(.set($0)) } content: { entries in
      VStack {
        Widget {
          displayPreview()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .if(let: file) { $0
          .fileExporter(isPresented: $showingExporter, document: $1, contentType: .json, defaultFilename: filename) {
            handleError { [result = $0] in debugPrint(try result.get()) }
          }
          .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.json]) { result in
            handleError {
              file = try DataFile(at: try result.get())
              try await entries.send(code.decode(file!.content, encoding))
            }
          }
        }
        .alert(isPresented: .init { error != nil } set: { _ in error = nil }, error: error) {}

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
      .animation(.default, value: preview)
      .task { update(entries.state) }
      .task(id: CombineHashable(entries.state, encoding)) { update(entries.state) }
      .compactDismissButton()
    }
  }

  @AppStorage("porter_encoding") private var encoding: Encoding = .daily

  @State private var showingExporter = false
  @State private var showingImporter = false

  @State private var error: ImportError?
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
      } catch let error as URLError where error.code == .noPermissionsToReadFile {
        self.error = .missingPermission
      } catch is URLError {
        self.error = .invalidURL
      } catch is DecodingError {
        self.error = .invalidFormat
      } catch let error as CocoaError where error.isCoderError {
        self.error = .invalidFormat
      } catch { debugPrint(error) }
    }
  }
}

extension Porter {
  enum ImportError: Error, LocalizedError {
    case invalidFormat, invalidURL, missingPermission

    var errorDescription: String? {
      switch self {
      case .invalidFormat: return String(localized: "INVALID_FORMAT_IMPORTERROR")
      case .invalidURL: return String(localized: "INVALID_URL_IMPORTERROR")
      case .missingPermission: return String(localized: "MISSING_PERMISSION_IMPORTERROR")
      }
    }
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

private extension Porter {
  @ViewBuilder func exporter(isLoading: Bool) -> some View {
    Button { showingExporter = true } label: { Label("EXPORT", systemImage: "square.and.arrow.up") }
      .accessibilityIdentifier("export-button")
      .if(isLoading) { $0
        .hidden()
        .overlay(content: ProgressView.init)
      }
  }

  @ViewBuilder func importer(isLoading: Bool) -> some View {
    Button { showingImporter = true } label: { Label("IMPORT", systemImage: "square.and.arrow.down") }
      .accessibilityIdentifier("import-button")
      .if(isLoading) { $0
        .hidden()
        .overlay(content: ProgressView.init)
      }
  }

  @ViewBuilder func formatPicker() -> some View {
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

  @ViewBuilder func displayPreview() -> some View {
    if let preview {
      Text(preview).lineLimit(10)
    } else { ProgressView() }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct Porter_Previews: PreviewProvider {
  static var previews: some View {
    Porter().previewInSheet()
      .environmentObject(Store(initialState: .init(), reducer: App()))
  }
}
#endif
