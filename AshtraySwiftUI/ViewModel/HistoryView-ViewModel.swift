//
//  HistoryView-ViewModel.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.12.21.
//

import Foundation
import MyOthers

extension HistoryView {
    @MainActor class ViewModel: SuperViewModel {
        @Published var date = Date()
        @Published var isEditing = false
        
        enum DisplayCategory: String, CaseIterable {
            case thisday = "This Day",
                 thisweek = "This Week",
                 thismonth = "This Month",
                 alltime = "Alltime"
        }
        
        func getDiplayValue(category: DisplayCategory) -> String {
            let id = Count.getID(from: date)
            let count: Double
            
            switch category {
            case .thisday: count = model.calculateSum(for: id, timespan: .day)
            case .thisweek: count = model.calculateSum(for: id, timespan: .week)
            case .thismonth: count = model.calculateSum(for: id, timespan: .month)
            case .alltime: count = model.calculateSum(for: id, timespan: .alltime)
            }
            
            return String(Int(count))
        }
        
        func addCig() {
            let id = Count.getID(from: date)
            model.edit(for: id)
        }
        
        func removeCig() {
            let id = Count.getID(from: date)
            model.edit(amount: -1, for: id)
        }
    }
}
