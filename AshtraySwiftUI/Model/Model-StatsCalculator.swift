//
//  Model-StatsCalculator.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 22.12.21.
//

import Foundation

extension Model {
    class StatsCalculator {
        enum Timespan: CaseIterable {
            case day, week, month, alltime
        }
        enum Interval: CaseIterable {
            case daily, weekly, monthly
        }
        
        private let counts: [CountType], startingID: CountIDType
        
        init(counts: [CountType], startingID: CountIDType = CountIDType()) {
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
                sum += getAmount(for: lowerID)
                lowerID.day += 1
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
