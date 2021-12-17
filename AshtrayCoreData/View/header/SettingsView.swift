//
//  Settings.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.07.21.
//

import SwiftUI
import MyJSONs
import MyDates
import MyCustomUI


struct SettingsView: View {
    @EnvironmentObject private var model: AshtrayModel
    
    @Binding var showSettings: Bool
    
    @State private var doc = JSONFile()
    @State private var showExporter = false; @State private var showImporter = false
    @State private var showWarning = false; @State private var showConfirmation = false
    @State private var confirmationTitle = ""; @State private var confirmationMessage = ""
    
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                Section(header: Text("Data")
                            .font(size: 15)
                            .customBackground()) {
                    HStack {
                        Button("export data") {
                            showExporter = true
                            encodeToJSON()
                        }
                        .buttonStyle(.borderless)
                        
                        Spacer()
                        Divider()
                        Spacer()
                        
                        Button("import data"){
                            showWarning = true
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(.horizontal)
                    .alert(isPresented: $showConfirmation) {
                        Alert(title: Text(confirmationTitle),
                              message: Text(confirmationMessage),
                              dismissButton: .default(Text("OK")))
                    }
                    .alert(isPresented: $showWarning) {
                        Alert(title: Text("Are you sure?"),
                              message: Text("This will irreversibly overwrite all current data!"),
                              primaryButton: .destructive(Text("Import")) {
                                    showImporter = true
                              }, secondaryButton: .cancel())
                    }
                    
                }
                .customRowBackground()
                
                Section(header: Text("start date")
                            .font(size: 15)
                            .customBackground()) {
                    DatePickerView($model.startingID)
                }
                .customRowBackground()
            }
            SymbolButton("xmark.circle") {
                withAnimation {
                    showSettings = false
                }
            }
            .padding(5)
        }
        .fileExporter(isPresented: $showExporter,
                      document: doc, contentType: .json, defaultFilename: "Ashtray-Counts (\(getString(Date())))",
                      onCompletion: exportAction)
        
        .fileImporter(isPresented: $showImporter,
                      allowedContentTypes: [.json], allowsMultipleSelection: false,
                      onCompletion: importAction)
    }
    
    private func encodeToJSON() {
        //TODO: Add json export functionality
        /*do {
            doc.data = try JSONEncoder().encode(model.counts)
        } catch {
            print("Failed to encode JSON")
        }*/
    }
    
    private func exportAction(result: Result<URL, Error>) -> Void {
        switch result {
        case .success: confirmationTitle = "Export successful!"; showConfirmation.toggle()
        case .failure: confirmationTitle = "Export failed!"; showConfirmation.toggle()
        }
    }
    
    private func importAction(result: Result<[URL], Error>) -> Void {
        //TODO: Add json import functionality
        /*do {
            let fileURL: URL = try result.get().first!
            if fileURL.startAccessingSecurityScopedResource() {
                let data = try Data(contentsOf: fileURL)
                fileURL.stopAccessingSecurityScopedResource()
                model.counts = try JSONDecoder().decode(CountCollectionType.self, from: data)
            } else { print("Access to file denied!")}
        } catch { print("Import failed!\n\(error.localizedDescription)") }
        switch result {
        case .success: confirmationTitle = "Import successful!"; showConfirmation.toggle()
        case .failure: confirmationTitle = "Import failed!"; showConfirmation.toggle()
        }*/
    }
    
    
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSettings: .constant(true))
            .preview()
    }
}
