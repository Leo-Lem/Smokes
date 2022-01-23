//
//  ImportExportController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 23.01.22.
//

import Foundation
import MyStorage
import SwiftUI
import UniformTypeIdentifiers

protocol TransferControllerProtocol {
    func export(result: Result<URL, Error>) throws
    func `import`(result: Result<[URL], Error>) throws -> (Preferences, [Entry])
}

class TransferController: TransferControllerProtocol {
    
    enum Status: Error {
        case importSuccess, importFailure(ImportError), exportSuccess, exportFailure(Error)
        enum ImportError: Error { case url, access, file, corrupted, decode, unknown(Error? = nil) }
    }
    
    func export(result: Result<URL, Error>) throws {
        switch result {
        case .success: throw Status.exportSuccess
        case .failure(let error): throw Status.exportFailure(error)
        }
    }
    
    func `import`(result: Result<[URL], Error>) throws -> (Preferences, [Entry]) {
        switch result {
        case .failure(let error): throw Status.importFailure(.unknown(error))
        case .success(let urls):
            guard let url = urls.first else { throw Status.importFailure(.url) }
            
            let file = try getFile(url)
            let contents = try getContents(file)
            
            return (contents.prefs, contents.entries)
        }
    }

}

extension TransferController {
    
    private func getFile(_ url: URL) throws -> FileWrapper {
        defer { url.stopAccessingSecurityScopedResource() }
        guard url.startAccessingSecurityScopedResource() else { throw Status.importFailure(.access) }
        
        guard let file = try? FileWrapper(url: url) else { throw Status.importFailure(.file) }
        
        return file
    }
    
    private func getContents(_ file: FileWrapper) throws -> JSONFile.Contents {
        guard let data = file.regularFileContents else { throw Status.importFailure(.corrupted) }
        guard let contents = try? JSONDecoder().decode(JSONFile.Contents.self, from: data) else { throw Status.importFailure(.decode) }
        
        return contents
    }
    
}


//MARK: - JSONFile type
struct JSONFile: FileDocument {
    private let contents: Contents
    
    init(_ prefs: Preferences, _ entries: [Entry]) {
        self.contents = Contents(prefs: prefs, entries: entries)
    }
    
    static var readableContentTypes = [UTType.json]
    
    struct Contents: Codable { let prefs: Preferences, entries: [Entry] }
    
    //MARK: not needed
    init(configuration: ReadConfiguration) throws {
        self.contents = Contents(prefs: Preferences.default, entries: [])
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(contents)
        let file = FileWrapper(regularFileWithContents: data)
        
        return file
    }
}
