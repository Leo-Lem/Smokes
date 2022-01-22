//
//  CalculationController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import Foundation
import MyDates
import MyOthers

enum CalculationTimespan {
    case day(_ date: Date),
         week(_ date: Date),
         month(_ date: Date),
         alltime(_ date: Date, _ startDate: Date)
}
enum CalculationInterval { case daily, weekly, monthly }

protocol CalculationControllerProtocol {
    func calculateTotal(
        for timespan: CalculationTimespan,
        in entries: [Entry]
    ) -> Int
    
    func calculateAverage(
        for timespan: CalculationTimespan,
        with interval: CalculationInterval,
        in entries: [Entry]
    ) -> Double
}

class CalculationController: CalculationControllerProtocol {
    
    func calculateTotal(
        for timespan: CalculationTimespan,
        in entries: [Entry]
    ) -> Int {
        let dates = getDates(for: timespan)
        let relevant = getEntries(for: dates, in: entries)
        let total = getTotal(for: relevant)
        
        return total
    }
    
    func calculateAverage(
        for timespan: CalculationTimespan,
        with interval: CalculationInterval,
        in entries: [Entry]
    ) -> Double {
        let total = calculateTotal(for: timespan, in: entries)
        let divisor = getDivisor(for: timespan, with: interval)
        let average = Double(total) / (divisor ?? 1)
        
        return average
    }
    
    //MARK: - actual calculation methods
    private func getDivisor(for timespan: CalculationTimespan, with interval: CalculationInterval) -> Double? {
        switch (timespan, interval) {
        case (.day, .daily): return 1
        case (.week(let date), .daily):
            return Double(date.distance(for: .weekOfYear, in: .day)!)
        case (.month(let date), .daily):
            return Double(date.distance(for: .month, in: .day)!)
        case (.month(let date), .weekly):
            return Double(date.distance(for: .month)!) / 7
        case (.alltime(let date, let startDate), .daily):
            return startDate.distance(to: date, in: .day)!
        case (.alltime(let date, let startDate), .weekly):
            return startDate.distance(to: date, in: .day)! / 7
        case (.alltime(let date, let startDate), .monthly):
            return startDate.distance(to: date, in: .month)!
        default: return nil
        }
    }
    
    private func getDates(for timespan: CalculationTimespan) -> [Date] {
        switch timespan {
        case .day(let date):
            return [date]
        case .week(let date):
            return date.enumerate(in: .weekOfYear) ?? []
        case .month(let date):
            return date.enumerate(in: .month) ?? []
        case .alltime(let date, let startDate):
            return date.enumerate(from: startDate, to: date) ?? []
        }
    }
    
    private func getEntries(for dates: [Date], in entries: [Entry]) -> [Entry] {
        var relevant = [Entry]()
        
        for date in dates {
            guard let entry = entries.first(where: { $0.id == Entry(date).id }) else { continue }
            relevant.append(entry)
        }
        
        return relevant
    }
    
    private func getTotal(for entries: [Entry]) -> Int { entries.reduce(0, { $0 + $1.amount }) }
}
