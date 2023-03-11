// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI
import UniformTypeIdentifiers

struct Porter: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init, send: ViewAction.send) { viewStore in
      VStack {
        if let file = viewStore.file {
          Widget {
            Text(file.preview)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
            .animation(.default, value: file.preview)
          
          Spacer()
        
          HStack {
            Widget {
              Button(systemImage: "square.and.arrow.down") { showingImporter = true }
                .fileImporter(isPresented: $showingImporter, allowedContentTypes: SmokesFile.readableContentTypes) {
                  do { viewStore.send(.importFile(try $0.get())) } catch { debugPrint(error) }
                }
                .padding()
            }
            
            Widget {
              HStack {
                Picker("", selection: viewStore.binding(get: \.format, send: { ViewAction.setFormat($0) })) {
                  ForEach(SmokesFile.readableContentTypes, id: \.self) { format in
                    Text(format.localizedDescription ?? "")
                  }
                }
                .pickerStyle(.segmented)
                
                Button(systemImage: "square.and.arrow.up") { showingExporter = true }
                  .fileExporter(
                    isPresented: $showingExporter,
                    document: file, contentType: viewStore.format, defaultFilename: "SmokesData"
                  ) {
                    do { debugPrint(try $0.get()) } catch { debugPrint(error) }
                  }
              }
              .padding()
            }
          }
          .imageScale(.large)
          .font(.headline)
        } else {
          ProgressView()
        }
      }
      .padding()
      .presentationDetents([.medium])
      .onAppear { viewStore.send(.createFile(viewStore.entries)) }
      .onChange(of: viewStore.entries) { viewStore.send(.createFile($0)) }
    }
  }
  
  @State private var showingExporter = false
  @State private var showingImporter = false
}

extension Porter {
  struct ViewState: Equatable {
    let entries: [Date]
    let format: UTType
    let file: SmokesFile?
    
    init(_ state: MainReducer.State) {
      entries = state.entries
      format = state.filePorter.format
      file = state.filePorter.file
    }
  }
  
  enum ViewAction {
    case setFormat(UTType)
    case createFile([Date])
    case importFile(URL)
    
    static func send(_ action: Self) -> MainReducer.Action {
      switch action {
      case let .setFormat(format): return .filePorter(.setFormat(format))
      case let .createFile(entries): return .filePorter(.createFile(entries))
      case let .importFile(url): return .importEntries(url)
      }
    }
  }
}

// MARK: - (PREVIEWS)

struct Porter_Previews: PreviewProvider {
  static var previews: some View {
    Porter()
      .environmentObject(Store(initialState: .preview, reducer: MainReducer()))
  }
}
