//
//  CloudStorageController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 24.01.22.
//

import Foundation
import CloudKit

actor CloudStorageController: StorageControllerProtocol {
    enum StorageError: Error { case save, fetch, decode, encode }
    
    private static let container = CKContainer(identifier: "iCloud.LeoLem.WordScramble")
    private let database = container.privateCloudDatabase
    
    private let entryIdentifier = "Entry", prefsIdentifier = "Preferences"
    
    func save(_ entries: [Entry]) async throws {
        let query = getQuery(for: entryIdentifier)
        
        let results = try? await getResults(with: query)
        
        let records: [CKRecord] = entries.compactMap { entry in
            let recordID = results?.first(where: { result in
                result.1["date"] as? Date == entry.id
            })?.0
            
            let record = recordID != nil ? CKRecord(recordType: entryIdentifier, recordID: recordID!): CKRecord(recordType: entryIdentifier)
            record["date"] = entry.id as CKRecordValue
            record["amount"] = entry.amount as CKRecordValue
            
            return record
        }
        
        try await modify(records)
    }
    
    func save(_ preferences: Preferences) async throws {
        let query = getQuery(for: prefsIdentifier)
        
        let record = (try? await getResults(with: query).first?.1) ?? CKRecord(recordType: prefsIdentifier)
        record["startDate"] = preferences.startDate as CKRecordValue
        
        try await modify([record])
    }
    
    func load() async throws -> [Entry] {
        let query = getQuery(for: entryIdentifier)
        guard
            let records = try? await getResults(with: query).map({ $0.1 })
        else { throw StorageError.fetch }
        
        let entries: [Entry] = try records.map {
            guard
                let id = $0["date"] as? Date,
                let amount = $0["amount"] as? Int
            else { throw StorageError.decode }
            
            return Entry(id, amount: amount)
        }
        
        return entries
    }
    
    func load() async throws -> Preferences {
        let query = getQuery(for: prefsIdentifier)
        
        guard
            let record = try? await getResults(with: query).first?.1,
            let startDate = record["startDate"] as? Date
        else { throw StorageError.fetch }
        
        return Preferences(startDate: startDate, cloudStore: true)
    }
}

extension CloudStorageController {
    private func getQuery(for identifier: String, predicate: NSPredicate = NSPredicate(format: "TRUEPREDICATE")) -> CKQuery {
        CKQuery(recordType: identifier, predicate: predicate)
    }
    
    private func getResults(with query: CKQuery) async throws -> [(CKRecord.ID, CKRecord)] {
        var results = [(CKRecord.ID, CKRecord)]()
        var cursor: CKQueryOperation.Cursor?
        
        while cursor != nil {
            guard let records = try? await database.records(matching: query) else { throw StorageError.fetch }
            
            cursor = records.queryCursor
            
            results += try records.matchResults.map {
                guard let result = try? $0.1.get() else { throw StorageError.decode }
                return ($0.0, result)
            }
        }
        
        return results
    }
    
    private func modify(_ records: [CKRecord]) async throws {
        do {
            _ = try await database.modifyRecords(saving: records, deleting: [], savePolicy: .allKeys, atomically: false)
        } catch { throw StorageError.save }
    }
}
