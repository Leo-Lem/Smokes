//
//  PrefView.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI

struct PrefView: View {
    @EnvironmentObject private var sc: StateController
    
    var body: some View {
        Content(
            prefs: sc.preferences, edit: edit,
            createFile: createFile,
            export: export, import: `import`,
            alert: alert
        )
    }
    
    @State private var alert = TransferAlert()
}

extension PrefView {
    private func edit(_ startDate: Date? = nil) {
        try? sc.editPreferences(startDate: startDate) //TODO: implement error handling
    }
    
    private func createFile() -> JSONFile { sc.getFile() }
    
    private func export(_ result: Result<URL, Error>) {
        do { try sc.export(result: result) }
        catch let status as TransferController.Status { alert = TransferAlert(status) } catch {}
    }
    
    private func `import`(_ result: Result<[URL], Error>) {
        do { try sc.import(result: result) }
        catch let status as TransferController.Status { alert = TransferAlert(status) } catch {}
    }
}

/*
 //MARK: ideas for settable preferences
 
 - start date (x)
 - import / export (JSON) (x)
 - cloud storage
 - default number of cigarettes to add per click
 - ...
 
 */

//MARK: - alerts for notifying about importing and exporting
extension PrefView {
    struct TransferAlert {
        let title: String?, message: String?
        
        init(_ status: TransferController.Status? = nil) {
            guard let status = status else {
                self.title = nil
                self.message = nil
                return
            }

            self.title = status.desc
            
            if case .importFailure(let error) = status {
                self.message = error.desc
            } else if case .exportFailure(let error) = status {
                self.message = error.localizedDescription
            } else {
                self.message = nil
            }
        }
    }
}

extension TransferController.Status {
    var desc: String {
        let desc: String
        
        switch self {
        case .importFailure: desc = "import-failed-title"~
        case .exportFailure: desc = "export-failed-title"~
        case .importSuccess: desc = "import-success-title"~
        case .exportSuccess: desc = "export-success-title"~
        }
        
        return desc
    }
}

extension TransferController.Status.ImportError {
    var desc: String {
        let desc: String
        
        switch self {
        case .url: desc = "import-failed-url"~
        case .access: desc = "import-failed-access"~
        case .file: desc = "import-failed-file"~
        case .corrupted: desc = "import-failed-corrupted"~
        case .decode: desc = "import-failed-decode"~
        case .unknown(let error): desc = "import-failed-unknown: \(error?.localizedDescription ?? "")"~
        }
        
        return desc
    }
}
