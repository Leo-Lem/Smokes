//
//  SettingsView-ViewModel.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.12.21.
//

import Foundation
import MyOthers

extension SettingsView {
    @MainActor class ViewModel: SuperViewModel {
        @Published var showExporter = false
        @Published var showImporter = false
        @Published var showConfirmation = false
        
        var completionTitle = "", completionMessage = ""
        
        var file: JSONFile {
            if let data = try? JSONEncoder().encode(model.counts) { return JSONFile(data) }
            else { return JSONFile() }
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
                    
                    model.counts = try JSONDecoder().decode([CountType].self, from: data)
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
