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
    func calculateStats(for id: CountCollectionIDType, timespan: IDSpanType, from startingID: CountCollectionIDType = Date()) -> Double {
        StatsCalculation.counts = self
        StatsCalculation.IDRanges.startingID = startingID
        return StatsCalculation.calculateSum(for: id, timespan: timespan)
    }
    
    //method for calculating the average of certain of certain elements in an array
    func calculateStats(for id: CountCollectionIDType, timespan: IDSpanType,  interval: IDIntervalType, from startingID: CountCollectionIDType = Date()) -> Double {
        StatsCalculation.counts = self
        StatsCalculation.IDRanges.startingID = startingID
        return StatsCalculation.calculateAverage(for: id, timespan: timespan, interval: interval)
    }
    
    private class StatsCalculation {
        static var counts: CountCollectionType = CountCollectionType()
        
        static func calculateSum(for id: CountCollectionIDType, timespan: IDSpanType) -> Double {
            let idRange = getIDRange(from: id, forTimespan: timespan)
            
            return getCountSum(in: idRange)
        }
        
        static func calculateAverage(for id: CountCollectionIDType, timespan: IDSpanType, interval: IDIntervalType) -> Double {
            let idRange = getIDRange(from: id, forTimespan: timespan)
            
            return getCountAverage(in: idRange, withInterval: interval)
        }
        
        private static func getCountSum(in idRange: ClosedRange<CountCollectionIDType>) -> Double {
            let distance = getDistance(of: idRange)
            var sum: Int = 0, lowerID = idRange.lowerBound
            
            for _ in 0...distance {
                sum += getAmount(for: lowerID)
                lowerID = incrementID(lowerID)
            }
            
            return Double(sum)
        }
        
        private static func getCountAverage(in idRange: ClosedRange<CountCollectionIDType>, withInterval interval: IDIntervalType) -> Double {
            var sum = getCountSum(in: idRange), distance = getDistance(of: idRange)
            
            switch interval {
            case .daily: break
            case .weekly: distance /= 7
            case .monthly: distance /= 30
            }
            
            return calculateAverage(sum: sum, distance: distance)
        }
        
        private static func getIDRange(from id: CountCollectionIDType, forTimespan timespan: IDSpanType) -> ClosedRange<CountCollectionIDType> {
            let idRange: ClosedRange<CountCollectionIDType>
            let idRanges = IDRanges(from: id)
            
            switch timespan {
            case .day: idRange = idRanges.day
            case .week: idRange = idRanges.week
            case .month: idRange = idRanges.month
            case .alltime: idRange = idRanges.alltime
            }
            
            return idRange
        }
        
        //TODO: Figure out how to pass in the startingID from the Array extension and making this struct private
        fileprivate struct IDRanges {
            static var startingID: CountCollectionIDType = CountCollectionIDType()
            private let baseID: CountCollectionIDType
            
            init(from id: CountCollectionIDType) {
                self.baseID = id
            }
            
            var day: ClosedRange<CountCollectionIDType> {
                baseID...baseID
            }
            
            var week: ClosedRange<CountCollectionIDType> {
                var from = baseID.getComponents(), to = baseID.getComponents()
                
                from.day! -= (from.weekday! - 1)
                to.day! += (7 - to.weekday!)
                
                return from.getDate()...to.getDate()
            }
            
            var month: ClosedRange<CountCollectionIDType> {
                var from = baseID.getComponents(), to = baseID.getComponents()
                
                from.day = 1
                to.month! += 1; to.day = 0
                
                return from.getDate()...to.getDate()
            }
            
            var alltime: ClosedRange<CountCollectionIDType> {
                return Self.startingID < baseID ? Self.startingID...baseID : baseID...baseID
            }
        }
        
        private static func getDistance(of idRange: ClosedRange<CountCollectionIDType>) -> Int {
            Calendar.current.dateComponents([.day], from: idRange.lowerBound, to: idRange.upperBound).day!
        }
        
        private static func findCount(for id: CountCollectionIDType) -> CountType? {
            counts.first { $0.wrappedId == id }
        }
        
        private static func getAmount(for id: CountCollectionIDType) -> Int {
            findCount(for: id)?.wrappedAmount ?? 0
        }
        
        private static func incrementID(_ id: CountCollectionIDType) -> CountCollectionIDType {
            id.addToValues([1], for: [.day])
        }
        
        private static func calculateAverage(sum: Double, distance: Int) -> Double {
            if distance > 0 {
                return sum / Double(distance)
            } else {
                return sum
            }
        }
    }
}
