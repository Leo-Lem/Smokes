//
//  AverageView-ViewModel.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.12.21.
//

import Foundation
import MyOthers

extension AverageView {
    @MainActor class ViewModel: SuperViewModel {
        @Published var timespan: Timespan = .alltime
        @Published var date = Date()
        
        enum Timespan: String, CaseIterable {
            case thisweek = "Week", thismonth = "Month", alltime = "Alltime"
        }

        enum Interval: String, CaseIterable {
            case daily = "Daily", weekly = "Weekly", monthly = "Monthly"
            
            func hideView(_ timespan: Timespan) -> Bool {
                switch self {
                case .daily: return false
                case .weekly: return timespan == .thisweek
                case .monthly: return timespan == .thisweek || timespan == .thismonth
                }
            }
        }
        
        func getDisplayValue(interval: Interval) -> String {
            let id = Count.getID(from: date)
            let average: Double
            
            switch (timespan, interval) {
            case (.thisweek, .daily): average = model.calculateAverage(for: id, timespan: .week, interval: .daily)
            case (.thismonth, .daily): average = model.calculateAverage(for: id, timespan: .month, interval: .daily)
            case (.thismonth, .weekly): average = model.calculateAverage(for: id, timespan: .month, interval: .weekly)
            case (.alltime, .daily): average = model.calculateAverage(for: id, timespan: .alltime, interval: .daily)
            case (.alltime, .weekly): average = model.calculateAverage(for: id, timespan: .alltime, interval: .weekly)
            case (.alltime, .monthly): average = model.calculateAverage(for: id, timespan: .alltime, interval: .monthly)
            default: average = 0
            }
            
            return String(format: "%.2f", average)
        }
    }
}
