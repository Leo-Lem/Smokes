//
//  File.swift
//  
//
//  Created by Leopold Lemmermann on 04.12.21.
//

import Foundation

public enum TimespanType: String, CaseIterable {
    case day = "Day", week = "Week", month = "Month", alltime = "All Time"
}
public enum IntervalType: String, CaseIterable {
    case day = "Daily", week = "Weekly", month = "Monthly"
}
public enum CalculationType: String, CaseIterable {
    case count = "Count", average = "Average", time = "Time"
}

public class StatsCalculation {
    public static var startingDate: Date = Date()
    
    public static func calculateStats(from counts: [String: Int], for date: Date,
                               timespan: TimespanType, interval: IntervalType = .day, type: CalculationType) -> Double {
        
        let dateRange = getDateRange(from: date, in: timespan)
        let distance = getDistance(for: dateRange)
        var sum = 0, avg = 0.0
        calculateSum(&sum, from: counts, with: distance, in: dateRange)
        calculateAverage(&avg, from: sum, with: distance, in: interval)
        
        switch type {
        case .count: return Double(sum)
        case .average: return avg
        default: return 0
        }
    }
    
    private static func getDateRange(from date: Date, in timespan: TimespanType) -> ClosedRange<Date> {
        var from = date.getComponents(), to = date.getComponents()
        
        switch timespan {
        case .week: from.day! -= (from.weekday! - 1); to.day! += (7 - to.weekday!)
        case .month: from.day = 1; to.month! += 1; to.day = 0
        case .alltime: from = StatsCalculation.startingDate.getComponents()
        default: break
        }
        
        return from.getDate() < to.getDate() ? from.getDate()...to.getDate() : from.getDate()...from.getDate()
    }
    
    private static func getDistance(for dateRange: ClosedRange<Date>) -> Int {
        Calendar.current.dateComponents([.day], from: dateRange.lowerBound, to: dateRange.upperBound).day!
    }
    
    private static func calculateSum(_ sum: inout Int, from counts: [String: Int], with distance: Int, in dateRange: ClosedRange<Date>) {
        var to = dateRange.upperBound
        for _ in 0...distance {
            if let count = counts[to.getID()] { sum += count }
            to = to.addToValues([-1], for: [.day])
        }
    }
    
    private static func calculateAverage(_ average: inout Double, from sum: Int, with distance: Int, in interval: IntervalType) {
        switch interval {
        case .day: average = Double(sum) / Double(distance)
        case .week: average = Double(sum)*7 / Double(distance)
        case .month: average = Double(sum)*30 / Double(distance)
        }
    }
}
