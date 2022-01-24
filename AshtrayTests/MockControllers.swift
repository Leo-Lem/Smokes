//
//  MockController.swift
//  AshtrayTests
//
//  Created by Leopold Lemmermann on 23.01.22.
//

import Foundation
@testable import Ashtray

actor MockCalculationController: CalculationControllerProtocol {
    func calculateTotal(for timespan: CalculationTimespan, in entries: [Entry]) -> Int {
        print("total calculated!")
        return 10
    }
    
    func calculateAverage(for timespan: CalculationTimespan, with interval: CalculationInterval, in entries: [Entry]) -> Double {
        print("average calculated!")
        return 10.0
    }
}

actor MockTransferController: TransferControllerProtocol {
    func export(result: Result<URL, Error>) throws {
        print("data exported!")
    }
    
    func `import`(result: Result<[URL], Error>) throws -> (Preferences, [Entry]) {
        print("data imported")
        return (Preferences.default, [])
    }
}

actor MockStorageController: StorageControllerProtocol {
    func save(_ entries: [Entry]) throws {
        print("entries saved!")
    }
    
    func save(_ preferences: Preferences) throws {
        print("preferences saved!")
    }
    
    func load() throws -> [Entry] {
        print("entries loaded!")
        return []
    }
    
    func load() throws -> Preferences {
        print("preferences loaded!")
        return Preferences.default
    }
}
