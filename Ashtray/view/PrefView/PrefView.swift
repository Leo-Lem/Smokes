//  Created by Leopold Lemmermann on 20.01.22.

import SwiftUI

/*
 // MARK: ideas for settable preferences
 
 - start date (x)
 - import / export (JSON) (x)
 - cloud storage (x)
 - default number of cigarettes to add per click
 - pack price for spending calculation
 
 */

struct PrefView: View {
  @EnvironmentObject private var sc: StateController
    
  var body: some View {
    Content(
      prefs: sc.preferences, edit: edit,
      createFile: createFile,
      export: sc.export, import: sc.import
    )
  }
    
  private func edit(_ startDate: Date? = nil, cloudStore: Bool? = nil) {
    try? sc.editPreferences(startDate: startDate, cloudStore: cloudStore) // TODO: implement error handling
  }
    
  private func createFile() -> JSONFile { sc.getFile() }
}

// MARK: - alerts for notifying about importing and exporting

extension PrefView {
  struct TransferAlert {
    let title: LocalizedStringKey?, message: LocalizedStringKey?
        
    init(_ status: TransferControllerImpl.Status? = nil) {
      guard let status = status else {
        self.title = nil
        self.message = nil
        return
      }

      self.title = status.desc
            
      if case .importFailure(let error) = status {
        self.message = error.desc
      } else if case .exportFailure(let error) = status {
        self.message = LocalizedStringKey(error.localizedDescription)
      } else {
        self.message = nil
      }
    }
  }
}

extension TransferControllerImpl.Status {
  var desc: LocalizedStringKey {
    switch self {
    case .importFailure: return "PREFERENCES_IMPORT_FAILURE"
    case .exportFailure: return "PREFERENCES_EXPORT_FAILURE"
    case .importSuccess: return "PREFERENCES_IMPORT_SUCCESS"
    case .exportSuccess: return "PREFERENCES_EXPORT_SUCCESS"
    }
  }
}

extension TransferControllerImpl.Status.ImportError {
  var desc: LocalizedStringKey {
    switch self {
    case .url: return "PREFERENCES_IMPORT_ERROR_URL"
    case .access: return "PREFERENCES_IMPORT_ERROR_ACCESS"
    case .file: return "PREFERENCES_IMPORT_ERROR_FILE"
    case .corrupted: return "PREFERENCES_IMPORT_ERROR_CORRUPTED"
    case .decode: return "PREFERENCES_IMPORT_ERROR_DECODE"
    case .unknown(let error): return "PREFERENCES_IMPORT_ERROR_UNKNOWN \(error?.localizedDescription ?? "")"
    }
  }
}
