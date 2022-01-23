//
//  TransferView.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 23.01.22.
//

import SwiftUI
import MyCustomUI

extension PrefView.Content {
    struct TransferView: View {
        let createFile: () -> JSONFile
        let export: (Result<URL, Error>) -> Void, `import`: (Result<[URL], Error>) -> Void
        
        var body: some View {
            HStack {
                SymbolButton("export-button-symbol"~, true: $exporter)
                    .font()
                    .fileExporter(
                        isPresented: $exporter,
                        document: createFile(),
                        contentType: .json,
                        defaultFilename: "default-export-filename"~,
                        onCompletion: export
                    )
                
                Spacer()
                
                Text("app-data-label"~)
                    .font("default-font"~)
                
                Spacer()
                
                SymbolButton("import-button-symbol"~, true: $importer)
                    .font()
                    .fileImporter(
                        isPresented: $importer,
                        allowedContentTypes: [.json],
                        allowsMultipleSelection: false,
                        onCompletion: `import`
                    )
            }
        }
        
        @State private var importer = false
        @State private var exporter = false
    }
}

//MARK: - Previews
struct TransferView_Previews: PreviewProvider {
    static var previews: some View {
        PrefView.Content.TransferView(
            createFile: { JSONFile(Preferences.default, []) },
            export: {_ in},
            import: {_ in})
    }
}
