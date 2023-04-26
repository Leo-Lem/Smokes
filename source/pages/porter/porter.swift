// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI
import UniformTypeIdentifiers

struct Porter: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store, observe: ViewState.init, send: ViewAction.send) { vs in
      VStack {
        Widget {
          displayPreview()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .if(let: vs.file) { view, file in view
              .fileExporter(
                isPresented: $showingExporter,
                document: file, contentType: .json, defaultFilename: String(localized: "SMOKES_FILENAME")
              ) {
                do { debugPrint(try $0.get()) } catch { debugPrint(error) }
              }
              .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.json]) {
                do { vs.send(.importFile(try $0.get())) } catch { debugPrint(error) }
              }
            }
        }
        .alert("IMPORT_FAILED", isPresented: vs.binding(get: \.importFailed, send: { _ in .dismissImportFailed })) {}

        Spacer()

        HStack {
          importer(isLoading: vs.file == nil && showingImporter)
          exporter(isLoading: vs.file == nil && showingExporter)
        }
        .imageScale(.large)
        .font(.headline)
      }
      .overlay(alignment: .topLeading) {
        Button(action: dismiss.callAsFunction) { Label("DISMISS", systemImage: "xmark") }
          .buttonStyle(.borderless)
          .padding()
      }
      .labelStyle(.iconOnly)
      .presentationDetents([.medium])
      // .presentationBackground(.clear) only for iOS 16.4
      .onAppear {
        vs.send(.changeCoder(coder))
        vs.send(.createFile)
        Task { preview = vs.file.flatMap { String(data: $0.content, encoding: .utf8) } }
      }
      .onChange(of: coder) { vs.send(.changeCoder($0)) }
      .onChange(of: vs.file) { newFile in
        Task {
          preview = nil
          preview = newFile.flatMap { String(data: $0.content, encoding: .utf8) } }
      }
    }
  }

  @State private var preview: String?
  @State private var showingExporter = false
  @State private var showingImporter = false
  @AppStorage("porter_fileCoder") private var coder: FileCoders = .daily

  @Environment(\.dismiss) private var dismiss
}

extension Porter {
  @ViewBuilder private func exporter(isLoading: Bool) -> some View {
    Widget {
      HStack {
        Picker("", selection: $coder) {
          ForEach(FileCoders.allCases, id: \.self) { coder in
            Text(LocalizedStringKey(coder.rawValue))
          }
        }
        .pickerStyle(.segmented)
        .accessibilityElement()
        .accessibilityLabel("PICK_FORMAT")
        .accessibilityValue(LocalizedStringKey(coder.rawValue))
        .accessibilityIdentifier("format-picker")

        Button { showingExporter = true } label: { Label("EXPORT", systemImage: "square.and.arrow.up") }
          .accessibilityIdentifier("export-button")
          .if(isLoading) { $0
            .hidden()
            .overlay(content: ProgressView.init)
          }
      }
    }
  }

  @ViewBuilder private func importer(isLoading: Bool) -> some View {
    Widget {
      Button { showingImporter = true } label: { Label("IMPORT", systemImage: "square.and.arrow.down") }
        .accessibilityIdentifier("import-button")
        .if(isLoading) { $0
          .hidden()
          .overlay(content: ProgressView.init)
        }
    }
    .fixedSize()
  }

  @ViewBuilder private func displayPreview() -> some View {
    if let preview {
      Text(preview).lineLimit(10)
    } else { ProgressView() }
  }
}

enum FileCoders: String, CaseIterable {
  case daily = "DAILY_FORMAT", exact = "EXACT_FORMAT" // , grouped = "GROUPED_FORMAT"

  var coder: Coder {
    switch self {
    case .daily: return .daily
    case .exact: return .exact
//    case .grouped: return .grouped
    }
  }
}

// MARK: - (PREVIEWS)

struct Porter_Previews: PreviewProvider {
  static var previews: some View {
    Porter()
      .environmentObject(Store(initialState: .init(), reducer: MainReducer()))
  }
}
