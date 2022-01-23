//
//  Content.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI
import MyCustomUI

extension PrefView {
    struct Content: View {
        let edit: (Date) -> Void
        
        let createFile: () -> JSONFile
        let export: (Result<URL, Error>) async throws -> Void,
            `import`: (Result<[URL], Error>) async throws -> Void
        
        var body: some View {
            VStack {
                Text("prefs-label"~).font("default-font"~, size: 30)
                
                Section {
                    TransferView(createFile: createFile, export: { result in
                        Task {
                            do { try await export(result) }
                            catch let status as TransferController.Status {
                                self.alert = TransferAlert(status)
                            } catch {}
                        }
                    }, import: { result in
                        Task {
                            do { try await `import`(result) }
                            catch let status as TransferController.Status {
                                self.alert = TransferAlert(status)
                            } catch {}
                        }
                    })
                        .font(size: 20)
                        .rowItem()
                }
                
                Section {
                    StartDatePicker(date: $startDate)
                        .font(size: 20)
                        .rowItem()
                        .onChange(of: startDate, perform: edit)
                }
                
                Spacer()
            }
            .alert(
                alert.title ?? "",
                isPresented: .constant(alert.title != nil),
                actions: {},
                message: { Text(alert.message ?? "") }
            ) //FIXME: Alert is displayed again once you dismiss the view
        }
        
        @State private var startDate: Date
        @State private var alert = TransferAlert()
        
        init(
            prefs: Preferences,
            edit: @escaping (Date) -> Void,
            createFile: @escaping () -> JSONFile,
            export: @escaping (Result<URL, Error>) async throws -> Void,
            `import`: @escaping (Result<[URL], Error>) async throws -> Void
        ) {
            self._startDate = State(initialValue: prefs.startDate)
            self.edit = edit
            
            self.createFile = createFile
            
            self.export = export
            self.import = `import`
        }
    }
}

//MARK: - Previews
struct PrefViewContent_Previews: PreviewProvider {
    static var previews: some View {
        PrefView.Content(
            prefs: Preferences.default, edit: {_ in},
            createFile: { JSONFile(Preferences.default, []) },
            export: {_ in}, import: {_ in})
    }
}
