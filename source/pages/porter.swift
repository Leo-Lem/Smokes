// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI
import UniformTypeIdentifiers

struct Porter: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init, send: ViewAction.send) { viewStore in
      Render(format: $format, file: viewStore.file) { viewStore.send(.importFile($0)) }
        .onAppear { viewStore.send(.createFile(viewStore.entries)) }
        .onChange(of: viewStore.entries) { viewStore.send(.createFile($0)) }
    }
  }
  
  @State private var format = UTType.json
}

extension Porter {
  struct ViewState: Equatable {
    let entries: [Date]
    let file: SmokesFile?
    
    init(_ state: MainReducer.State) {
      entries = state.entries
      file = state.filePorter.file
    }
  }
  
  enum ViewAction {
    case createFile([Date])
    case importFile(URL)
    
    static func send(_ action: Self) -> MainReducer.Action {
      switch action {
      case let .createFile(entries): return .filePorter(.createFile(entries))
      case let .importFile(url): return .importEntries(url)
      }
    }
  }
}

extension Porter {
  struct Render: View {
    @Binding var format: UTType
    let file: SmokesFile?
    let importFile: (URL) -> Void
    
    var body: some View {
      VStack {
        if let file {
          Widget {
            Text(file.generatePreview(for: format))
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
          .animation(.default, value: file.generatePreview(for: format))
          
          Spacer()
        
          HStack {
            Widget {
              Button { showingImporter = true } label: { Label("IMPORT", systemImage: "square.and.arrow.down") }
                .accessibilityIdentifier("import-button")
                .fileImporter(isPresented: $showingImporter, allowedContentTypes: SmokesFile.readableContentTypes) {
                  do { importFile(try $0.get()) } catch { debugPrint(error) }
                }
            }
            
            Widget {
              HStack {
                Picker("", selection: $format) {
                  ForEach(SmokesFile.readableContentTypes, id: \.self) { format in
                    Text(format.localizedDescription ?? "")
                  }
                }
                .pickerStyle(.segmented)
                .accessibilityElement()
                .accessibilityLabel("PICK_FORMAT")
                .accessibilityValue(format.localizedDescription ?? "")
                .accessibilityAction(named: "TOGGLE_FORMAT") { format = format == .json ? .plainText : .json }
                .accessibilityIdentifier("format-picker")
                
                Button{ showingExporter = true } label: { Label("EXPORT", systemImage: "square.and.arrow.up")}
                  .accessibilityIdentifier("export-button")
                  .fileExporter(
                    isPresented: $showingExporter,
                    document: file, contentType: format, defaultFilename: String(localized: "SMOKES_FILENAME")
                  ) {
                    do { debugPrint(try $0.get()) } catch { debugPrint(error) }
                  }
              }
            }
          }
          .imageScale(.large)
          .font(.headline)
        } else {
          ProgressView()
        }
      }
      .labelStyle(.iconOnly)
      .presentationDetents([.medium])
    }
    
    @State private var showingExporter = false
    @State private var showingImporter = false
  }
}

// MARK: - (PREVIEWS)

struct Porter_Previews: PreviewProvider {
  static var previews: some View {
    let amounts = [Date.now - 86400: 10, .now: 8, .now + 86400: 14]
    
    Group {
      Porter.Render(format: .constant(.plainText), file: .init(amounts)) { _ in }
        .previewDisplayName("Text")
      
      Porter.Render(format: .constant(.json), file: .init(amounts)) { _ in }
        .previewDisplayName("JSON")
      
      Porter.Render(format: .constant(.json), file: nil) { _ in }
        .previewDisplayName("Loading")
    }
    .padding()
  }
}
