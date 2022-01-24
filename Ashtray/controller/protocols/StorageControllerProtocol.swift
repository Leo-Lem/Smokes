//
//  StorageController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 24.01.22.
//

import Foundation

protocol StorageControllerProtocol: Actor {
    func save(_ entries: [Entry]) async throws
    func save(_ preferences: Preferences) async throws
    
    func load() async throws -> [Entry]
    func load() async throws -> Preferences
}
