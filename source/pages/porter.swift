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
            Text(file.generatePreview(for: format))
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
          .animation(.default, value: file.generatePreview(for: format))
          
          Spacer()
        
          HStack {
            Widget {
              Button(systemImage: "square.and.arrow.down") { showingImporter = true }
                .fileImporter(isPresented: $showingImporter, allowedContentTypes: SmokesFile.readableContentTypes) {
                  do { viewStore.send(.importFile(try $0.get())) } catch { debugPrint(error) }
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
                
                Button(systemImage: "square.and.arrow.up") { showingExporter = true }
                  .fileExporter(
                    isPresented: $showingExporter,
                    document: file, contentType: format, defaultFilename: "SmokesData"
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
      .presentationDetents([.medium])
      .onAppear { viewStore.send(.createFile(viewStore.entries)) }
      .onChange(of: viewStore.entries) { viewStore.send(.createFile($0)) }
    }
  }
  
  @State private var showingExporter = false
  @State private var showingImporter = false
  
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

// MARK: - (PREVIEWS)

struct Porter_Previews: PreviewProvider {
  static var previews: some View {
    Porter()
      .environmentObject(Store(initialState: .preview, reducer: MainReducer()))
  }
}
