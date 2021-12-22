//
//  AshtrayCoreDataModel.swift
//  AshtrayCoreData
//
//  Created by Leopold Lemmermann on 14.12.21.
//

import Foundation
import MyOthers

class Model: ObservableObject {
    //TODO: rename startingID to startID
    //TODO: try out objects for startID and counts with loading and saving methods
    var startingID: CountIDType = Count.getID(from: CountIDType()){
        willSet { self.objectWillChange.send() }
        didSet { saveStartingID() }
    }
    
    private func loadStartingID() {
        guard let id = UserDefaults.standard.object(forKey:"startingID") as? CountIDType else { return }
        self.startingID = id
    }
    private func saveStartingID() {
        UserDefaults.standard.set(startingID, forKey: "startingID")
    }
    
    //the counts and related methods
    var counts: [CountType] = [] {
        willSet { self.objectWillChange.send() }
        didSet {
            modifyCounts(&counts)
            try? saveCounts()
        }
    }
    
    private let docsURL = FileManager.documentsDirectory.appendingPathComponent("SavedCounts")
    private func loadCounts() throws {
        let data = try Data(contentsOf: docsURL)
        self.counts = try JSONDecoder().decode([CountType].self, from: data)
        //self.counts = UserDefaults.standard.getObject(forKey: "counts", castTo: [CountType].self) ?? []
    }
    private func saveCounts() throws {
        let data = try JSONEncoder().encode(counts)
        try data.write(to: docsURL, options: .atomic)
        //UserDefaults.standard.setObject(counts, forKey: "counts")
    }
    private func modifyCounts(_ counts: inout [CountType]) {
        counts.removeAll { $0.amount <= 0 }
        counts.sort()
    }
    
    init() {
        loadStartingID()
        try? loadCounts()
    }
    
    //calculating the stats
    func calculateSum(for id: CountIDType, timespan: StatsCalculator.Timespan) -> Double {
        let calculator = StatsCalculator(counts: self.counts, startingID: self.startingID)
        return calculator.sum(for: id, timespan: timespan)
    }
    
    func calculateAverage(for id: CountIDType, timespan: StatsCalculator.Timespan,  interval: StatsCalculator.Interval) -> Double {
        let calculator = StatsCalculator(counts: self.counts, startingID: self.startingID)
        return calculator.average(for: id, timespan: timespan, interval: interval)
    }
    
    //editing the model objects
    func edit(amount: Int = 1, for id: CountIDType = Count.getID(from: Date())) {
        if let index = counts.firstIndex(where: { $0.id == id }) {
            counts[index].amount += amount
        } else {
            let count = CountType(id: id, amount: amount)
            counts.append(count)
        }
    }
}
