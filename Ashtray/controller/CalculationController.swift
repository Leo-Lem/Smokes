//
//  CalculationController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import Foundation
import MyDates
import MyOthers

actor CalculationController: CalculationControllerProtocol {
    
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
        let average = Double(total) / divisor
        
        return average
    }
    
    //MARK: - actual calculation methods
    private func getDivisor(for timespan: CalculationTimespan, with interval: CalculationInterval) -> Double {
        let divisor: Double
        
        switch (timespan, interval) {
        case (.week(let date), .daily):
            divisor = Double(date.distance(for: .weekOfYear, in: .day)!)
        case (.month(let date), .daily):
            divisor = Double(date.distance(for: .month, in: .day)!)
        case (.month(let date), .weekly):
            divisor = Double(date.distance(for: .month)!) / 7
        case (.alltime(let date, let startDate), .daily):
            divisor = startDate.distance(to: date, in: .day)!
        case (.alltime(let date, let startDate), .weekly):
            divisor = startDate.distance(to: date, in: .day)! / 7
        case (.alltime(let date, let startDate), .monthly):
            divisor = startDate.distance(to: date, in: .month)!
        default: divisor = 1
        }
        
        return divisor > 1 ? divisor : 1
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
