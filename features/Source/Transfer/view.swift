// Created by Leopold Lemmermann on 05.03.23.

import Code
import Components
import ComposableArchitecture
import Extensions
import SwiftUI
import enum Generated.L10n

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
          Button { send(.importButtonTapped) } label: {
            Label(L10n.Transfer.import, systemImage: "square.and.arrow.down")
          }
            .accessibilityIdentifier("import-button")
            .fileImporter(isPresented: $store.importing, allowedContentTypes: [.json]) { send(.import($0)) }
            .if(store.loadingImport) { $0
              .hidden()
              .overlay(content: ProgressView.init)
            }

          Picker("", selection: $store.encoding) {
            ForEach(Encoding.allCases, id: \.self) { encoding in
              Text(encoding.title)
            }
          }
          .pickerStyle(.segmented)
          .accessibilityElement()
          .accessibilityLabel(L10n.Transfer.format)
          .accessibilityValue(store.encoding.title)
          .accessibilityIdentifier("format-picker")

          Button { send(.exportButtonTapped) } label: {
            Label(L10n.Transfer.export, systemImage: "square.and.arrow.up")
          }
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

fileprivate extension Transfer.State {
  var filename: String { L10n.Transfer.filename }
}

fileprivate extension Encoding {
  var title: String {
    switch self {
    case .daily: return L10n.Transfer.Format.daily
    case .grouped: return L10n.Transfer.Format.grouped
    case .exact: return L10n.Transfer.Format.exact
    }
  }
}

#Preview {
  TransferView(store: Store(initialState: Transfer.State(), reducer: Transfer.init))
    .previewInSheet()
}
