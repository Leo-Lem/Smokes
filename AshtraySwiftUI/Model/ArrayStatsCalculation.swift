//
//  File.swift
//  
//
//  Created by Leopold Lemmermann on 04.12.21.
//

import Foundation

enum IDSpanType: CaseIterable {
    case day, week, month, alltime
}
enum IDIntervalType: CaseIterable {
    case daily, weekly, monthly
}

extension Array where Element == CountType {
    //method for calculating the sum of certain elements in an array
    func calculateSum(for id: CountIDType, timespan: IDSpanType, from startingID: CountIDType = Date()) -> Double {
        StatsCalculation.counts = self
        StatsCalculation.startingID = startingID
        return StatsCalculation.getSum(for: id, timespan: timespan)
    }
    
    //method for calculating the average of certain of certain elements in an array
    func calculateAverage(for id: CountIDType, timespan: IDSpanType,  interval: IDIntervalType, from startingID: CountIDType = Date()) -> Double {
        StatsCalculation.counts = self
        StatsCalculation.startingID = startingID
        return StatsCalculation.getAverage(for: id, timespan: timespan, interval: interval)
    }
    
    //where the calculation of the stats happens
    private class StatsCalculation {
        static var counts = [CountType]()
        static var startingID = CountIDType()
        
        static func getSum(for id: CountIDType, timespan: IDSpanType) -> Double {
            let idRange = getIDRange(from: id, forTimespan: timespan)
            
            return calculateCountSum(in: idRange)
        }
        
        static func getAverage(for id: CountIDType, timespan: IDSpanType, interval: IDIntervalType) -> Double {
            let idRange = getIDRange(from: id, forTimespan: timespan)
            
            return calculateCountAverage(in: idRange, interval: interval)
        }
        
        private static func calculateCountSum(in idRange: ClosedRange<CountIDType>) -> Double {
            let distance = Int(getDistance(of: idRange))
            var sum: Int = 0, lowerID = idRange.lowerBound
            
            for _ in 0...distance {
                lowerID.day += 1
                sum += getAmount(for: lowerID)
            }
            
            return Double(sum)
        }
        
        private static func calculateCountAverage(in idRange: ClosedRange<CountIDType>, interval: IDIntervalType) -> Double {
            let sum = calculateCountSum(in: idRange), distance: Double
            
            switch interval {
            case .daily: distance = getDistance(of: idRange)
            case .weekly: distance = getDistance(of: idRange, in: .week)
            case .monthly: distance = getDistance(of: idRange, in: .month)
            }
            
            return calculateAverage(sum: sum, distance: distance)
        }
        
        private static func getIDRange(from id: CountIDType, forTimespan timespan: IDSpanType) -> ClosedRange<CountIDType> {
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
        
        private static func getDistance(of idRange: ClosedRange<CountIDType>, in unit: Date.DistanceUnit = .day) -> Double {
            idRange.lowerBound.distance(to: idRange.upperBound, in: unit)
        }
        
        private static func findCount(for id: CountIDType) -> CountType? {
            counts.first { $0.id == id }
        }
        
        private static func getAmount(for id: CountIDType) -> Int {
            findCount(for: id)?.amount ?? 0
        }
        
        private static func calculateAverage(sum: Double, distance: Double) -> Double {
            if distance > 0 {
                return sum / distance
            } else {
                return sum
            }
        }
    }
}
