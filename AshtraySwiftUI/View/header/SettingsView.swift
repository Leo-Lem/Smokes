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
    @EnvironmentObject private var viewModel: AshtrayViewModel
    @State private var showExporter = false; @State private var showImporter = false
    @State private var showWarning = false; @State private var showConfirmation = false
    @State private var confirmationTitle = ""; @State private var confirmationMessage = ""
    
    private var file: JSONFile {
        if let data = try? JSONEncoder().encode(viewModel.counts) {
            return JSONFile(data)
        } else {
            return JSONFile()
        }
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Button {
                    showExporter = true
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
                    showWarning = true
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .font()
                        .padding()
                }
            }
            .layoutListItem()
            .alert(isPresented: $showConfirmation) { confirmationAlert }
            .alert(isPresented: $showWarning) { warningAlert }
            .fileExporter(isPresented: $showExporter,
                          document: file, contentType: .json,
                          defaultFilename: "Ashtray-Counts (\(Date().getString()))",
                          onCompletion: exportAction)
            .fileImporter(isPresented: $showImporter,
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
    
    private var confirmationAlert: Alert {
        Alert(title: Text(confirmationTitle),
              message: Text(confirmationMessage),
              dismissButton: .default(Text("OK")))
    }
    
    private var warningAlert: Alert {
        Alert(title: Text("Are you sure?"),
              message: Text("This will irreversibly overwrite all current data!"),
              primaryButton: .destructive(Text("Import")) {
                    showImporter = true
              }, secondaryButton: .cancel())
    }
    
    private func exportAction(result: Result<URL, Error>) -> Void {
        switch result {
        case .success: confirmationTitle = "Export successful!"; showConfirmation.toggle()
        case .failure: confirmationTitle = "Export failed!"; showConfirmation.toggle()
        }
    }
    
    private func importAction(result: Result<[URL], Error>) -> Void {
        do {
            let fileURL: URL = try result.get().first!
            if fileURL.startAccessingSecurityScopedResource() {
                let data = try Data(contentsOf: fileURL)
                fileURL.stopAccessingSecurityScopedResource()
                viewModel.counts = try JSONDecoder().decode([CountType].self, from: data)
            } else { print("Access to file denied!")}
        } catch { print("Import failed!\n\(error.localizedDescription)") }
        switch result {
        case .success: confirmationTitle = "Import successful!"; showConfirmation.toggle()
        case .failure: confirmationTitle = "Import failed!"; showConfirmation.toggle()
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preview()
    }
}
