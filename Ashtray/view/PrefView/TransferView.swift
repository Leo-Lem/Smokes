//  Created by Leopold Lemmermann on 23.01.22.

import MyCustomUI
import SwiftUI

extension PrefView.Content {
  struct TransferView: View {
    let createFile: () -> JSONFile
    let export: (Result<URL, Error>) -> Void, `import`: (Result<[URL], Error>) -> Void
        
    var body: some View {
      HStack {
        SymbolButton("square.and.arrow.up", true: $exporter)
          .fileExporter(
            isPresented: $exporter,
            document: createFile(),
            contentType: .json,
            defaultFilename: _defaultFilename,
            onCompletion: export
          )
                
        Spacer()
                
        Text("PREFERENCES_APPDATA_LABEL")
                
        Spacer()
                
        SymbolButton("square.and.arrow.down", true: $importer)
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

// MARK: - Previews

struct TransferView_Previews: PreviewProvider {
  static var previews: some View {
    PrefView.Content.TransferView(
      createFile: { JSONFile(Preferences.default, []) },
      export: { _ in },
      import: { _ in }
    )
  }
}
