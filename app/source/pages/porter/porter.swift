// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI
import UniformTypeIdentifiers

// TODO: add import error and alert

struct Porter: View {
  @EnvironmentObject private var store: StoreOf<App>

  var body: some View {
    WithViewStore(store, observe: ViewState.init, send: ViewAction.send) { vs in
      VStack {
        Widget {
          displayPreview()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .animation(.default, value: preview)
        .if(let: vs.file) { view, file in view
          .fileExporter(
            isPresented: $showingExporter,
            document: file, contentType: .json, defaultFilename: String(localized: "SMOKES_FILENAME")
          ) {
            do { debugPrint(try $0.get()) } catch { debugPrint(error) }
          }
          .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.json]) {
            do {
              vs.send(.setData(try DataFile(at: try $0.get()).content))
            } catch { debugPrint(error) }
          }
        }

        Spacer()

        Widget {
          HStack {
            importer(isLoading: vs.file == nil && showingImporter)
            formatPicker()
            exporter(isLoading: vs.file == nil && showingExporter)
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
      .onAppear {
        vs.send(.selectCoder(encoding))
        vs.send(.encode)
      }
      .onChange(of: encoding) {
        vs.send(.encode)
        vs.send(.selectCoder($0))
      }
      .onChange(of: vs.file) { newFile in
        preview = newFile.flatMap { String(data: $0.content, encoding: .utf8) }
      }
    }
  }

  @State private var preview: String?
  @State private var showingExporter = false
  @State private var showingImporter = false
  @AppStorage("porter_fileCoder") private var encoding: EntriesEncoding = .daily

  @Environment(\.dismiss) private var dismiss
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
      ForEach(EntriesEncoding.allCases, id: \.self) { encoding in
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

extension EntriesEncoding: RawRepresentable {
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
