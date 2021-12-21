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

class Model {
    var startingID: CountIDType {
        get { UserDefaults.standard.object(forKey:"startingID") as? CountIDType ?? CountIDType() }
        set { UserDefaults.standard.set(Count.getID(from: newValue), forKey: "startingID") }
    }
    
    var counts: [CountType] {
        get { UserDefaults.standard.getObject(forKey: "counts", castTo: [CountType].self) ?? [] }
        set {
            let modifiedNewValue = newValue.filter { $0.amount > 0 }.sorted()
            UserDefaults.standard.setObject(modifiedNewValue, forKey: "counts")
        }
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
    func edit(amount: Int = 1, for id: CountIDType = CountIDType()) {
        if let index = counts.firstIndex(where: { $0.id == id }) {
            counts[index].amount += amount
        } else {
            let count = CountType(id: id, amount: amount)
            counts.append(count)
        }
    }
}

//the backend calculations
extension Model {
    private class StatsCalculator {
        let counts: [CountType]
        let startingID: CountIDType
        
        init(from counts: [CountType], startingID: CountIDType = CountIDType()) {
            self.counts = counts
            self.startingID = startingID
        }
        
        func sum(for id: CountIDType, timespan: Timespan) -> Double {
            let idRange = getIDRange(from: id, forTimespan: timespan)
            
            return calculateSum(in: idRange)
        }
        
        func average(for id: CountIDType, timespan: Timespan, interval: Interval) -> Double {
            let idRange = getIDRange(from: id, forTimespan: timespan)
            
            return calculateAverage(in: idRange, interval: interval)
        }
        
        //private methods to handle the calculations
        private func calculateSum(in idRange: ClosedRange<CountIDType>) -> Double {
            let distance = Int(getDistance(of: idRange))
            var sum: Int = 0, lowerID = idRange.lowerBound
            
            for _ in 0...distance {
                lowerID.day += 1
                sum += getAmount(for: lowerID)
            }
            
            return Double(sum)
        }
        
        private func calculateAverage(in idRange: ClosedRange<CountIDType>, interval: Interval) -> Double {
            let sum = calculateSum(in: idRange), distance: Double
            
            switch interval {
            case .daily: distance = getDistance(of: idRange)
            case .weekly: distance = getDistance(of: idRange, in: .week)
            case .monthly: distance = getDistance(of: idRange, in: .month)
            }
            
            return calculateAverage(sum: sum, distance: distance)
        }
        
        private func getIDRange(from id: CountIDType, forTimespan timespan: Timespan) -> ClosedRange<CountIDType> {
            var from = id, to = id
            
            switch timespan {
            case .day: break
            case .week:
                from.day -= (from.weekday - 1)
                to.day += (7 - to.weekday)
            case .month:
                from.day = 1
                to.month += 1
                to.day = 0
            case .alltime:
                from = startingID
            }
            
            if from <= to { return from...to }
            else { return id...id }
        }
        
        private func getDistance(of idRange: ClosedRange<CountIDType>, in unit: Date.DistanceUnit = .day) -> Double {
            idRange.lowerBound.distance(to: idRange.upperBound, in: unit)
        }
        
        private func findCount(for id: CountIDType) -> CountType? {
            counts.first { $0.id == id }
        }
        
        private func getAmount(for id: CountIDType) -> Int {
            findCount(for: id)?.amount ?? 0
        }
        
        private func calculateAverage(sum: Double, distance: Double) -> Double {
            if distance > 0 {
                return sum / distance
            } else {
                return sum
            }
        }
    }
}
