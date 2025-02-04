// Created by Leopold Lemmermann on 05.03.23.

import Components
import ComposableArchitecture
import SwiftUI
import Extensions
import Code

@ViewAction(for: Transfer.self)
public struct TransferView: View {
  @ComposableArchitecture.Bindable public var store: StoreOf<Transfer>

  public var body: some View {
    VStack {
      Widget {
        if let preview = store.preview {
          Text(preview)
            .lineLimit(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
          ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
      .alert($store.scope(state: \.alert, action: \.alert))

      Spacer()

      Widget {
        HStack {
          Button { send(.importButtonTapped) } label: { Label("IMPORT", systemImage: "square.and.arrow.down") }
            .accessibilityIdentifier("import-button")
            .fileImporter(isPresented: $store.importing, allowedContentTypes: [.json]) { send(.import($0)) }
            .if(store.loadingImport) { $0
              .hidden()
              .overlay(content: ProgressView.init)
            }

          Picker("", selection: $store.encoding) {
            ForEach(Encoding.allCases, id: \.self) { encoding in
              Text(LocalizedStringKey(encoding.rawValue))
            }
          }
          .pickerStyle(.segmented)
          .accessibilityElement()
          .accessibilityLabel("PICK_FORMAT")
          .accessibilityValue(LocalizedStringKey(store.encoding.rawValue))
          .accessibilityIdentifier("format-picker")

          Button { send(.exportButtonTapped) } label: { Label("EXPORT", systemImage: "square.and.arrow.up") }
            .accessibilityIdentifier("export-button")
            .fileExporter(
              isPresented: $store.exporting, document: store.file, contentType: .json, defaultFilename: store.filename
            ) { send(.export($0))}
            .if(store.loadingExport) { $0
              .hidden()
              .overlay(content: ProgressView.init)
            }

        }
      }
      .imageScale(.large)
      .font(.headline)
    }
    .padding(5)
    .labelStyle(.iconOnly)
    .presentationDetents([.medium])
    .presentationBackground(.ultraThinMaterial, legacy: Color("BackgroundColor"))
    .onAppear { send(.appear) }
  }

  public init(store: StoreOf<Transfer>) { self.store = store }
}

extension Encoding {
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

#Preview {
  TransferView(store: Store(initialState: Transfer.State(), reducer: Transfer.init))
    .previewInSheet()
}
