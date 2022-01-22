//
//  StateController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import Foundation
import MyOthers

final class StateController: ObservableObject {
    
    var preferences: Preferences = .default {
        willSet { DispatchQueue.main.async { self.objectWillChange.send() } }
    }
    
    var entries: [Entry] = [] {
        willSet { DispatchQueue.main.async { self.objectWillChange.send() } }
    }
    
    let storageController: StorageControllerProtocol
    let calculationController: CalculationControllerProtocol
    
    init(storageController: StorageControllerProtocol = LocalStorageController(),
         calculationController: CalculationControllerProtocol = CalculationController()) {
        self.storageController = storageController
        self.calculationController = calculationController
        
        self.preferences ?= try? loadPrefs()
        self.entries ?= try? loadEntries()
    }
    
}

//MARK: - editing entries
extension StateController {
    func add(_ amount: Int, on date: Date) throws {
        if let index = getIndex(Entry(date)) {
            entries[index].amount += amount
        } else {
            let entry = Entry(date, amount: amount)
            
            entries.append(entry)
        }
        
        try saveEntries()
    }
    
    private func getIndex(_ entry: Entry) -> Int? { entries.firstIndex { $0.id == entry.id } }
}

//MARK: - storage
extension StateController {
    func saveEntries() throws {
        try storageController.save(self.entries)
    }
    
    func loadEntries() throws -> [Entry] {
        try storageController.loadEntries()
    }
    
    func savePrefs() throws {
        try storageController.save(self.preferences)
    }
    
    func loadPrefs() throws -> Preferences {
        try storageController.loadPreferences()
    }
}

//MARK: - calculation
extension StateController {
    struct Total: Hashable {
        enum Timespan { case thisday, thisweek, thismonth, alltime }
        
        let kind: Timespan, date: Date
    }
    
    func calculate(total: Total) -> Int {
        let timespan: CalculationTimespan
        
        switch total.kind {
        case .thisday: timespan = .day(total.date)
        case .thisweek: timespan = .week(total.date)
        case .thismonth: timespan = .month(total.date)
        case .alltime: timespan = .alltime(total.date, preferences.startDate)
        }
        
        return calculationController.calculateTotal(for: timespan, in: entries)
    }
    
    struct Average: Hashable {
        enum Timespan { case thisweek, thismonth, alltime }
        enum Interval { case daily, weekly, monthly }
        
        let date: Date
        var kind: (Timespan, Interval) { (timespan, interval) }
        private let timespan: Timespan, interval: Interval
        
        init(kind: (Timespan, Interval), date: Date) {
            self.timespan = kind.0
            self.interval = kind.1
            self.date = date
        }
    }
    
    func calculate(average: Average) -> Double {
        let timespan: CalculationTimespan, interval: CalculationInterval
        
        switch average.kind {
        case (.thisweek, .daily):
            timespan = .week(average.date)
            interval = .daily
        case (.thismonth, .daily):
            timespan = .month(average.date)
            interval = .daily
        case (.alltime, .daily):
            timespan = .alltime(average.date, preferences.startDate)
            interval = .daily
        case (.thismonth, .weekly):
            timespan = .month(average.date)
            interval = .weekly
        case (.alltime, .weekly):
            timespan = .alltime(average.date, preferences.startDate)
            interval = .weekly
        case (.alltime, .monthly):
            timespan = .alltime(average.date, preferences.startDate)
            interval = .monthly
        default: return 0
        }
        
        return calculationController.calculateAverage(for: timespan, with: interval, in: entries)
    }
}

//MARK: - preferences
extension StateController {
    struct Preferences: Codable {
        var startDate: Date
        
        static let `default` = Preferences(startDate: Date())
    }
    
    func editPreferences(
        startDate: Date? = nil
    ) throws {
        preferences.startDate ?= startDate
        
        try savePrefs()
    }
}
