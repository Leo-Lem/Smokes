//
//  StorageController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import Foundation

protocol StorageControllerProtocol {
    typealias Preferences = StateController.Preferences
    
    func save(_ entries: [Entry]) throws
    func save(_ preferences: Preferences) throws
    
    func loadEntries() throws -> [Entry]
    func loadPreferences() throws -> Preferences
}

class LocalStorageController: StorageControllerProtocol {
    enum StorageError: Error { case encode } //TODO: implement error handling
    
    
    func save(_ entries: [Entry]) throws {
        //TODO: implement saving
    }
    
    func loadEntries() throws -> [Entry] {
        //TODO: implement loading
        return []
    }
    
    func save(_ preferences: Preferences) throws {
        //TODO: implement saving prefs
    }
    
    func loadPreferences() throws -> Preferences {
        //TODO: implement loading prefs
        return Preferences.default
    }
}
