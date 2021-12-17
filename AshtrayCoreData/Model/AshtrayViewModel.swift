//
//  CountModel.swift
//  AshtrayCoreData
//
//  Created by Leopold Lemmermann on 12.12.21.
//

import Foundation

class AshtrayViewModel: ObservableObject {
    func calculateMain(category: CountCategories.Main) -> String {
        let model = AshtrayModel()
        let id: CountCollectionIDType = getCountCollectionID(from: Date())
        let count: Double
        
        switch category {
        case .today: count = model.counts.calculateStats(for: id, timespan: .day)
        case .yesterday: count = model.counts.calculateStats(for: id - 86400, timespan: .day)
        case .thisweek: count = model.counts.calculateStats(for: id, timespan: .week)
        case .thismonth: count = model.counts.calculateStats(for: id, timespan: .month)
        case .alltime: count = model.counts.calculateStats(for: id, timespan: .alltime, from: model.startingID)
        }
        
        return String(Int(count))
    }
    
    func calculateHistory(for date: Date, category: CountCategories.History) -> String {
        let model = AshtrayModel()
        let id: CountCollectionIDType = getCountCollectionID(from: date)
        let count: Double
        
        switch category {
        case .thisday: count = model.counts.calculateStats(for: id, timespan: .day)
        case .thisweek: count = model.counts.calculateStats(for: id, timespan: .week)
        case .thismonth: count = model.counts.calculateStats(for: id, timespan: .month)
        case .alltime: count = model.counts.calculateStats(for: id, timespan: .alltime, from: model.startingID)
        }
        
        return String(Int(count))
    }
    
    func calculateAverage(for date: Date, category: CountCategories.Average.Span, interval: CountCategories.Average.Interval) -> String {
        let model = AshtrayModel()
        let id: CountCollectionIDType = getCountCollectionID(from: date)
        let average: Double
        
        switch (category, interval) {
        case (.thisweek, .daily): average = model.counts.calculateStats(for: id, timespan: .week, interval: .daily)
        case (.thismonth, .daily): average = model.counts.calculateStats(for: id, timespan: .month, interval: .daily)
        case (.thismonth, .weekly): average = model.counts.calculateStats(for: id, timespan: .month, interval: .weekly)
        case (.alltime, .daily): average = model.counts.calculateStats(for: id, timespan: .alltime, interval: .daily, from: model.startingID)
        case (.alltime, .weekly): average = model.counts.calculateStats(for: id, timespan: .alltime, interval: .weekly, from: model.startingID)
        case (.alltime, .monthly): average = model.counts.calculateStats(for: id, timespan: .alltime, interval: .monthly, from: model.startingID)
        default: average = 0
        }
        
        return String(format: "%.2f", average)
    }
}
