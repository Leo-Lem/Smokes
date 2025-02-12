// Created by Leopold Lemmermann on 05.03.23.

import Code
import Components
import ComposableArchitecture
import Extensions
import SwiftUI

@ViewAction(for: Transfer.self)
public struct TransferView: View {
  @Bindable public var store: StoreOf<Transfer>

  public var body: some View {
    VStack {
      Group {
        if let preview = store.preview {
          Text(preview)
            .lineLimit(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
          ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
      .widgetStyle()
      .alert($store.scope(state: \.alert, action: \.alert))
      .animation(.default, value: store.preview)

      Spacer()

      HStack {
        Button(String(localized: "import", bundle: .module), systemImage: "square.and.arrow.down") {
          send(.importButtonTapped, animation: .default)
        }
        .accessibilityIdentifier("import-button")
        .fileImporter(isPresented: $store.importing, allowedContentTypes: [.json]) { send(.import($0)) }
        .if(store.loadingImport) { $0
          .hidden()
          .overlay(content: ProgressView.init)
        }

        Picker(String(localized: "pick format", bundle: .module), selection: $store.encoding) {
          ForEach(Encoding.allCases, id: \.self) { encoding in
            Text(encoding.title)
          }
        }
        .pickerStyle(.segmented)
        .accessibilityElement()
        .accessibilityValue(store.encoding.title)
        .accessibilityIdentifier("format-picker")

        Button(String(localized: "export", bundle: .module), systemImage: "square.and.arrow.up") {
          send(.exportButtonTapped, animation: .default)
        }
        .accessibilityIdentifier("export-button")
        .fileExporter(
          isPresented: $store.exporting, document: store.file, contentType: .json, defaultFilename: "smokes"
        ) { send(.export($0))}
        .if(store.loadingExport) { $0
          .hidden()
          .overlay(content: ProgressView.init)
        }
      }
      .widgetStyle()
      .imageScale(.large)
      .font(.headline)
    }
    .padding(5)
    .labelStyle(.iconOnly)
    .presentationDetents([.medium])
    .presentationBackground(.ultraThinMaterial)
    .onAppear { send(.appear, animation: .default) }
  }

  public init(store: StoreOf<Transfer>) { self.store = store }
}

fileprivate extension Encoding {
  var title: String {
    switch self {
    case .daily: return String(localized: "daily")
    case .grouped: return String(localized: "exact")
    case .exact: return String(localized: "grouped")
    }
  }
}

#Preview {
  TransferView(store: Store(initialState: Transfer.State(), reducer: Transfer.init))
    .previewInSheet()
}
