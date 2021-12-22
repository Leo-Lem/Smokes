//
//  AshtrayCoreDataModel.swift
//  AshtrayCoreData
//
//  Created by Leopold Lemmermann on 14.12.21.
//

import Foundation
import MyOthers

typealias CountType = Count
typealias CountIDType = Date

struct Count: Codable, Hashable, Comparable {
    let id: CountIDType
    var amount: Int
    
    static func getID(from date: Date) -> CountIDType {
        date.getComponents([.day, .month, .year]).getDate()
    }
    
    static func <(lhs: Count, rhs: Count) -> Bool {
        lhs.id < rhs.id
    }
}

class Model: ObservableObject {
    var startingID: CountIDType {
        willSet { self.objectWillChange.send() }
        didSet { UserDefaults.standard.set(Count.getID(from: startingID), forKey: "startingID") }
    }
    
    //TODO: change the saving to of the counts to the app directory
    var counts: [CountType] {
        willSet { self.objectWillChange.send() }
        didSet { UserDefaults.standard.setObject(counts.filter { $0.amount > 0 }.sorted(), forKey: "counts") }
    }
    
    init() {
        self.startingID = UserDefaults.standard.object(forKey:"startingID") as? CountIDType ?? CountIDType()
        self.counts = UserDefaults.standard.getObject(forKey: "counts", castTo: [CountType].self) ?? []
    }

    enum Timespan: CaseIterable {
        case day, week, month, alltime
    }
    enum Interval: CaseIterable {
        case daily, weekly, monthly
    }
    
    //calculating the stats
    func calculateSum(for id: CountIDType, timespan: Timespan) -> Double {
        let calculator = StatsCalculator(from: self.counts, startingID: self.startingID)
        return calculator.sum(for: id, timespan: timespan)
    }
    
    func calculateAverage(for id: CountIDType, timespan: Timespan,  interval: Interval) -> Double {
        let calculator = StatsCalculator(from: self.counts, startingID: self.startingID)
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
