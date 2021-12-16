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
            
            return calculateCountAverage(in: idRange, withInterval: interval)
        }
        
        private static func getIDRange(from id: CountIDType, forTimespan timespan: IDSpanType) -> ClosedRange<CountIDType> {
            let idRange: ClosedRange<CountIDType>
            let idRanges = IDRanges(from: id)
            
            switch timespan {
            case .day: idRange = idRanges.day
            case .week: idRange = idRanges.week
            case .month: idRange = idRanges.month
            case .alltime: idRange = idRanges.alltime
            }
            
            return idRange
        }
        
        private struct IDRanges {
            private var startingID: CountIDType {
                StatsCalculation.startingID
            }
            private let baseID: CountIDType
            
            init(from id: CountIDType) {
                self.baseID = id
            }
            
            var day: ClosedRange<CountIDType> {
                baseID...baseID
            }
            
            var week: ClosedRange<CountIDType> {
                var from = baseID.getComponents(), to = baseID.getComponents()
                
                from.day! -= (from.weekday! - 1)
                to.day! += (7 - to.weekday!)
                
                return from.getDate()...to.getDate()
            }
            
            var month: ClosedRange<CountIDType> {
                var from = baseID.getComponents(), to = baseID.getComponents()
                
                from.day = 1
                to.month! += 1; to.day = 0
                
                return from.getDate()...to.getDate()
            }
            
            var alltime: ClosedRange<CountIDType> {
                self.startingID < baseID ? self.startingID...baseID : baseID...baseID
            }
        }
        
        private static func calculateCountSum(in idRange: ClosedRange<CountIDType>) -> Double {
            let distance = getDistance(of: idRange)
            var sum: Int = 0, lowerID = idRange.lowerBound
            
            for i in 0...distance {
                let id = incrementID(lowerID, by: i)
                sum += getAmount(for: id)
            }
            
            return Double(sum)
        }
        
        private static func calculateCountAverage(in idRange: ClosedRange<CountIDType>, withInterval interval: IDIntervalType) -> Double {
            var sum = calculateCountSum(in: idRange), distance = getDistance(of: idRange)
            
            switch interval {
            case .daily: break
            case .weekly: distance /= 7
            case .monthly: distance /= 30
            }
            
            return calculateAverage(sum: sum, distance: distance)
        }
        
        private static func getDistance(of idRange: ClosedRange<CountIDType>) -> Int {
            Calendar.current.dateComponents([.day], from: idRange.lowerBound, to: idRange.upperBound).day!
        }
        
        private static func findCount(for id: CountIDType) -> CountType? {
            counts.first { $0.id == id }
        }
        
        private static func getAmount(for id: CountIDType) -> Int {
            findCount(for: id)?.amount ?? 0
        }
        
        private static func incrementID(_ id: CountIDType, by i: Int) -> CountIDType {
            id.addToValues([i], for: [.day])
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
