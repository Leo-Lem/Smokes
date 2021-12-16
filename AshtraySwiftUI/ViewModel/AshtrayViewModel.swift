//
//  CountModel.swift
//  AshtrayCoreData
//
//  Created by Leopold Lemmermann on 12.12.21.
//

import Foundation

class AshtrayViewModel: ObservableObject {
    //connection to the model
    private let model = AshtrayModel()
    
    //handing through the model values for the view
    var counts: [CountType] {
        get { model.counts }
        set {
            objectWillChange.send()
            model.counts = newValue
        }
    }
    var startingID: CountIDType {
        get { model.startingID }
        set {
            objectWillChange.send()
            model.startingID = newValue
        }
    }
    
    //adding/changing model objects
    func addCig(on date: Date = Date()) {
        let id = Count.getID(from: date)
        
        if let index = counts.firstIndex(where: { $0.id == id }) {
            counts[index].amount += 1
        } else {
            let count = CountType(id: id, amount: 1)
            counts.append(count)
        }
    }
    
    func removeCig(on date: Date = Date()) {
        let id = Count.getID(from: date)
        
        if let index = counts.firstIndex(where: { $0.id == id }) {
            if counts[index].amount > 0 {
                counts[index].amount -= 1
            }
        }
    }
    
    //fetching/calculating data for the views to display
    func calculateMain(category: CountCategories.Main) -> String {
        let id = Count.getID(from: Date())
        let count: Double
        
        switch category {
        case .today:
            count = model.counts.calculateSum(for: id, timespan: .day)
        case .yesterday:
            count = model.counts.calculateSum(for: id - 86400, timespan: .day)
        case .thisweek:
            count = model.counts.calculateSum(for: id, timespan: .week)
        case .thismonth:
            count = model.counts.calculateSum(for: id, timespan: .month)
        case .alltime:
            count = model.counts.calculateSum(for: id, timespan: .alltime, from: model.startingID)
        }
        
        return String(Int(count))
    }
    
    func calculateHistory(for date: Date, category: CountCategories.History) -> String {
        let id = Count.getID(from: date)
        let count: Double
        
        switch category {
        case .thisday: count = model.counts.calculateSum(for: id, timespan: .day)
        case .thisweek: count = model.counts.calculateSum(for: id, timespan: .week)
        case .thismonth: count = model.counts.calculateSum(for: id, timespan: .month)
        case .alltime: count = model.counts.calculateSum(for: id, timespan: .alltime, from: model.startingID)
        }
        
        return String(Int(count))
    }
    
    func calculateAverage(for date: Date, category: CountCategories.Average.Span, interval: CountCategories.Average.Interval) -> String {
        let id = Count.getID(from: date)
        let average: Double
        
        switch (category, interval) {
        case (.thisweek, .daily): average = model.counts.calculateAverage(for: id, timespan: .week, interval: .daily)
        case (.thismonth, .daily): average = model.counts.calculateAverage(for: id, timespan: .month, interval: .daily)
        case (.thismonth, .weekly): average = model.counts.calculateAverage(for: id, timespan: .month, interval: .weekly)
        case (.alltime, .daily): average = model.counts.calculateAverage(for: id, timespan: .alltime, interval: .daily, from: model.startingID)
        case (.alltime, .weekly): average = model.counts.calculateAverage(for: id, timespan: .alltime, interval: .weekly, from: model.startingID)
        case (.alltime, .monthly): average = model.counts.calculateAverage(for: id, timespan: .alltime, interval: .monthly, from: model.startingID)
        default: average = 0
        }
        
        return String(format: "%.2f", average)
    }
    
    //different categories of displayed values
    typealias Main = CountCategories.Main
    typealias History = CountCategories.History
    typealias AverageSpan = CountCategories.Average.Span
    typealias AverageInterval = CountCategories.Average.Interval
    
    class CountCategories {
        enum Main: String, CaseIterable {
            case today = "Today", yesterday = "Yesterday", thisweek = "This Week", thismonth = "This Month", alltime = "Alltime"
        }

        enum History: String, CaseIterable {
            case thisday = "This Day", thisweek = "This Week", thismonth = "This Month", alltime = "Alltime"
        }
        
        class Average {
            enum Span: String, CaseIterable {
                case thisweek = "Week", thismonth = "Month", alltime = "Alltime"
            }

            enum Interval: String, CaseIterable {
                case daily = "Daily", weekly = "Weekly", monthly = "Monthly"
                
                func hideView(_ timespan: Span) -> Bool {
                    switch self {
                    case .daily: return false
                    case .weekly: return timespan == .thisweek
                    case .monthly: return timespan == .thisweek || timespan == .thismonth
                    }
                }
            }
        }
    }
}
