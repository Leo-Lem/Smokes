//
//  DayCounts.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 13.08.21.
//

import SwiftUI
import MyDates

let uDefaults = UserDefaults.standard

public func calculate(from counts: [String: Int], for date: Date, timespan: TimespanType, interval: IntervalType = .day, type: CalculationType) -> Double {
    StatsCalculation.calculateStats(from: counts, for: date, timespan: timespan, interval: interval, type: type)
}

enum CountType: String, CaseIterable { case tdy = "Today", yst = "Yesterday", twk = "This Week", tmt = "This Month", atc = "Alltime" }
enum HistoryCountType: String, CaseIterable { case tdy = "This Day", twk = "This Week", tmt = "This Month", atc = "Alltime"}
enum AvgTimespanType: String, CaseIterable { case wk = "Week", mt = "Month", at = "Alltime" }
enum AvgIntervalType: String, CaseIterable { case dly = "Daily", wly = "Weekly", mly = "Monthly" }

let dateFormatter = DateFormatter(withDateFormat: "dd.MM.yyyy")

class AshtrayModel: ObservableObject {
    @Published var installationDate: Date = Date() {
        didSet {
            uDefaults.set(installationDate.getString(), forKey: "installationDate")
            StatsCalculation.startingDate = installationDate
        }
    }
    @Published var counts = [String: Int]() {
        didSet {
            uDefaults.set(counts, forKey: "counts")
        }
    }
    @Published var packs = [String: Int]() {
        didSet {
            uDefaults.set(packs, forKey: "packs")
        }
    }
    
    init() {
        if let fetchedDate = uDefaults.object(forKey:"installationDate") { installationDate = getDate(fetchedDate as! String) }
        else { uDefaults.set(getString(Date()), forKey: "installationDate") }
        
        counts = (uDefaults.object(forKey: "counts") as? [String:Int] ?? counts).filter { $0.value > 0 }
        packs = (uDefaults.object(forKey: "packs") as? [String:Int] ?? packs).filter { $0.value > 0 }
    }
}

extension AshtrayModel {
    func calcMain(from dictionary: [String:Int], type: CountType) -> String {
        let count: Double
        switch type {
        case .tdy: count = calculate(from: dictionary, for: Date(), timespan: .day, type: .count)
        case .yst: count = calculate(from: dictionary, for: Date().yesterdaysDate(), timespan: .day, type: .count)
        case .twk: count = calculate(from: dictionary, for: Date(), timespan: .week, type: .count)
        case .tmt: count = calculate(from: dictionary, for: Date(), timespan: .month, type: .count)
        case .atc: count = calculate(from: dictionary, for: Date(), timespan: .alltime, type: .count)
        }
        return String(Int(count))
    }
    
    func calcHist(_ date: Date, from dictionary: [String:Int], type: HistoryCountType) -> String {
        let count: Double
        switch type {
        case .tdy: count = calculate(from: dictionary, for: date, timespan: .day, type: .count)
        case .twk: count = calculate(from: dictionary, for: date, timespan: .week, type: .count)
        case .tmt: count = calculate(from: dictionary, for: date, timespan: .month, type: .count)
        case .atc: count = calculate(from: dictionary, for: date, timespan: .alltime, type: .count)
        }
        return String(Int(count))
    }
    
    func calcAvg(_ date: Date, from dictionary: [String:Int], timespan: AvgTimespanType, interval: AvgIntervalType) -> String {
        let avg: Double
        switch (timespan, interval) {
        case (.wk, .dly): avg = calculate(from: dictionary, for: date, timespan: .week, interval: .day, type: .average)
        case (.mt ,.dly): avg = calculate(from: dictionary, for: date, timespan: .month, interval: .day, type: .average)
        case (.mt ,.wly): avg = calculate(from: dictionary, for: date, timespan: .month, interval: .week, type: .average)
        case (.at ,.dly): avg = calculate(from: dictionary, for: date, timespan: .alltime, interval: .day, type: .average)
        case (.at ,.wly): avg = calculate(from: dictionary, for: date, timespan: .alltime, interval: .week, type: .average)
        case (.at ,.mly): avg = calculate(from: dictionary, for: date, timespan: .alltime, interval: .month, type: .average)
        default: avg = 0
        }
        return String(format: "%.2f", avg)
    }
}
