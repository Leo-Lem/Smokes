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

enum PackInfo: String, CaseIterable { case price = "Price", amount = "Amount", Brand = "Brand" }

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
                Section(header: Text("Data").font(size: 15).customBackground()) {
                    HStack {
                        Button("export data", action: export)
                            .buttonStyle(.borderless)
                            .alert(isPresented: $showConfirmation) {
                                Alert(title: Text(confirmationTitle), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
                            }
                        Spacer(); Divider(); Spacer()
                        Button("import data", action: { showWarning.toggle() })
                            .buttonStyle(.borderless)
                            .alert(isPresented: $showWarning) {
                                Alert(title: Text("Are you sure?"), message: Text("This will irreversibly overwrite all current data!"), primaryButton: .destructive(Text("Import")) { showImporter.toggle() }, secondaryButton: .cancel())
                            }
                    }.padding(.horizontal)
                }.customRowBackground()
                
                Section(header: Text("start date").font(size: 15).customBackground()) {
                    DatePickerView($model.installationDate)
                }.customRowBackground()
                
                Section(header: Text("pack defaults").font(size: 15).customBackground()) {
                    ForEach(PackInfo.allCases, id: \.self) { packInfo in
                        Text(packInfo.rawValue)
                    }
                }.customRowBackground()
            }
            SymbolButtonView("xmark.circle") { withAnimation { showSettings = false } }
                .padding(5)
        }
        .fileExporter(isPresented: $showExporter, document: doc, contentType: .json, defaultFilename: "Ashtray-Counts (\(getString(Date())))") { result in
            switch result {
            case .success: confirmationTitle = "Export successful!"; showConfirmation.toggle()
            case .failure: confirmationTitle = "Export failed!"; showConfirmation.toggle()
            }
        }
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.json], allowsMultipleSelection: false) { result in
            do {
                let fileURL: URL = try result.get().first!
                if fileURL.startAccessingSecurityScopedResource() {
                    let data = try Data(contentsOf: fileURL)
                    fileURL.stopAccessingSecurityScopedResource()
                    model.counts = try JSONDecoder().decode([String: Int].self, from: data)
                } else { print("Access to file denied!")}
            } catch { print("Import failed!\n\(error.localizedDescription)") }
            switch result {
            case .success: confirmationTitle = "Import successful!"; showConfirmation.toggle()
            case .failure: confirmationTitle = "Import failed!"; showConfirmation.toggle()
            }
<<<<<<< HEAD
            SymbolButton("xmark.circle") {
                withAnimation {
                    showSettings = false
                }
            }
            .padding(5)
=======
>>>>>>> parent of ab469f5 (Managed to get it working at least.)
        }
    }
}

extension SettingsView {
    init(_ showSettings: Binding<Bool>) {
        self._showSettings = showSettings
    }
}

extension SettingsView {
    private func export() {
        do {
            doc.data = try JSONEncoder().encode(model.counts)
        } catch {
            print("Failed to encode JSON")
        }
        showExporter.toggle()
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(.constant(true)).preview()
    }
}
