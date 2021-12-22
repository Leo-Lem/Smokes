//
//  MainView-ViewModel.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.12.21.
//

import Foundation

extension MainView {
    @MainActor class ViewModel: SuperViewModel {
        enum DisplayCategory: String, CaseIterable {
            case today = "Today",
                 yesterday = "Yesterday",
                 thisweek = "This Week",
                 thismonth = "This Month",
                 alltime = "Alltime"
        }
        
        func getDiplayValue(category: DisplayCategory) -> String {
            let id = Count.getID(from: Date())
            let count: Double
            
            switch category {
            case .today: count = model.calculateSum(for: id, timespan: .day)
            case .yesterday: count = model.calculateSum(for: id - 86400, timespan: .day)
            case .thisweek: count = model.calculateSum(for: id, timespan: .week)
            case .thismonth: count = model.calculateSum(for: id, timespan: .month)
            case .alltime: count = model.calculateSum(for: id, timespan: .alltime)
            }
            
            return String(Int(count))
        }
        
        func addCig() -> Void {
            model.edit()
        }
        
        func removeCig() -> Void {
            model.edit(amount: -1)
        }
    }
}
