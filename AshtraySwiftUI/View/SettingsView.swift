//
//  Settings.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.07.21.
//

import SwiftUI
import MyCustomUI
import MyOthers

struct SettingsView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ScrollView {
            HStack {
                Button {
                    viewModel.showExporter = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font()
                        .padding()
                }
                
                Spacer()
                
                Text("Data")
                    .font(size: 15)
                
                Spacer()
                
                Button {
                    viewModel.showWarning = true
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .font()
                        .padding()
                }
            }
            .layoutListItem()
            .alert(isPresented: $viewModel.showWarning) { viewModel.warningAlert }
            .alert(isPresented: $viewModel.showConfirmation) { viewModel.completionAlert }
            .fileExporter(isPresented: $viewModel.showExporter,
                          document: viewModel.file, contentType: .json, defaultFilename: "Ashtray-Counts",
                          onCompletion: exportAction)
            .fileImporter(isPresented: $viewModel.showImporter,
                          allowedContentTypes: [.json], allowsMultipleSelection: false,
                          onCompletion: importAction)
            
            HStack {
                Text("Start Date")
                    .font(size: 15)
                    .padding()
                DatePicker($viewModel.startingID, to: Date())
                    .padding()
            }
            .layoutListItem()
        }
        .padding(.vertical)
    }
    
    private func exportAction(result: Result<URL, Error>) { viewModel.exportAction(result: result) }
    private func importAction(result: Result<[URL], Error>) { viewModel.importAction(result: result)}
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preview()
    }
}
