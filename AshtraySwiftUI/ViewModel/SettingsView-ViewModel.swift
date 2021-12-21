//
//  SettingsView-ViewModel.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.12.21.
//

import SwiftUI
import MyOthers

extension SettingsView {
    @MainActor class ViewModel: ObservableObject {
        private let model = Model()
        
        @Published var showExporter = false
        @Published var showImporter = false
        @Published var showWarning = false
        @Published var showConfirmation = false
        
        var counts: [CountType] {
            get { model.counts }
            set {
                objectWillChange.send()
                model.counts = newValue
            }
        }
        var startingID: CountIDType {
            get { model.startingID }
            set {
                objectWillChange.send()
                model.startingID = newValue
            }
        }
        
        var file: JSONFile {
            if let data = try? JSONEncoder().encode(counts) { return JSONFile(data) }
            else { return JSONFile() }
        }
        
        //an alert giving a warning before data is imported
        var warningAlert: Alert {
            Alert(title: Text("Are you sure?"),
                  message: Text("This will irreversibly overwrite all current data!"),
                  primaryButton: .destructive(Text("Import")) { self.showImporter = true },
                  secondaryButton: .cancel())
        }
        
        //an alert giving information about the status of the export or import
        var completionTitle = "", completionMessage = ""
        var completionAlert: Alert {
            Alert(title: Text(completionTitle),
                  message: Text(completionMessage),
                  dismissButton: .default(Text("OK")))
        }
        
        func exportAction(result: Result<URL, Error>) -> Void {
            switch result {
            case .success:
                completionTitle = "Export successful!"
                self.showConfirmation = true
            case .failure:
                completionTitle = "Export failed!"
                self.showConfirmation = true
            }
        }
        
        func importAction(result: Result<[URL], Error>) -> Void {
            do {
                let fileURL: URL = try result.get().first!
                
                if fileURL.startAccessingSecurityScopedResource() {
                    let data = try Data(contentsOf: fileURL)
                    fileURL.stopAccessingSecurityScopedResource()
                    
                    counts = try JSONDecoder().decode([CountType].self, from: data)
                } else {
                    self.completionMessage = "Access to file denied!"
                }
            } catch {
                self.completionMessage = error.localizedDescription
            }
            
            switch result {
            case .success:
                self.completionTitle = "Import successful!"
                self.showConfirmation = true
            case .failure:
                self.completionTitle = "Import failed!"
                self.showConfirmation = true
            }
        }
    }
}
