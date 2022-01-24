//
//  StorageController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import Foundation

actor LocalStorageController: StorageControllerProtocol {
    enum StorageError: Error { case save, fetch, decode, encode }
    
    private let dir = FileManager.documentsDirectory.appendingPathComponent("entries")
    private let prefKey = "preferences"
    
    func save(_ entries: [Entry]) throws {
        guard let data = try? JSONEncoder().encode(entries) else { throw StorageError.encode }
        guard (try? data.write(to: dir)) != nil else { throw StorageError.save }
    }
    
    func load() throws -> [Entry] {
        guard let data = try? Data(contentsOf: dir) else { throw StorageError.fetch }
        guard let entries = try? JSONDecoder().decode([Entry].self, from: data) else { throw StorageError.decode }
        return entries
    }
    
    func save(_ preferences: Preferences) throws {
        guard let data = try? JSONEncoder().encode(preferences) else { throw StorageError.encode }
        UserDefaults.standard.set(data, forKey: prefKey)
    }
    
    func load() throws -> Preferences {
        guard let data = UserDefaults.standard.object(forKey: prefKey) as? Data else { throw StorageError.fetch }
        guard let prefs = try? JSONDecoder().decode(Preferences.self, from: data) else { throw StorageError.decode }
        
        return prefs
    }
}
