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
    enum StorageError: Error { case encode, notFound, decode } //TODO: implement error handling
    
    
    func save(_ entries: [Entry]) throws {
        //TODO: implement saving
    }
    
    func loadEntries() throws -> [Entry] {
        //TODO: implement loading
        return []
    }
    
    func save(_ preferences: Preferences) throws {
        guard let data = try? JSONEncoder().encode(preferences) else { throw StorageError.encode}
        UserDefaults.standard.set(data, forKey: "preferences-save-key"~)
    }
    
    func loadPreferences() throws -> Preferences {
        guard let data = UserDefaults.standard.object(forKey: "preferences-save-key"~) as? Data else { throw StorageError.notFound }
        guard let prefs = try? JSONDecoder().decode(Preferences.self, from: data) else { throw StorageError.decode }
        
        return prefs
    }
}
