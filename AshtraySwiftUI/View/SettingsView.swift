//
//  Settings.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.07.21.
//

import SwiftUI
import MyCustomUI

struct SettingsView: View {
    @ObservedObject var viewModel = ViewModel()
    
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
                    viewModel.showImporter = true
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .font()
                        .padding()
                }
            }
            .layoutListItem()
            .alert(isPresented: $viewModel.showConfirmation) { completionAlert }
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
                DatePicker($viewModel.startingDate, to: Date())
                    .padding()
            }
            .layoutListItem()
        }
        .padding(.vertical)
    }
    
    //TODO: add a new alert notifying of the consequences of an import (overwriting all current data)
    //an alert giving information about the status of the export or import
    private var completionAlert: Alert {
        Alert(title: Text(viewModel.completionTitle),
              message: Text(viewModel.completionMessage),
              dismissButton: .default(Text("OK")))
    }
    
    private func exportAction(result: Result<URL, Error>) { viewModel.exportAction(result: result) }
    private func importAction(result: Result<[URL], Error>) { viewModel.importAction(result: result) }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preview()
    }
}
