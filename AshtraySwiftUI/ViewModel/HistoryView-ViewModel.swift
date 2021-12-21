//
//  HistoryView-ViewModel.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.12.21.
//

import SwiftUI
import MyOthers

extension HistoryView {
    @MainActor class ViewModel: ObservableObject {
        private let model = Model()
        var startingDate: Date { model.startingID.getDate() }
        
        @Published var date = Date()
        //TODO: redesign the editing structure
        @Published var editing = Editing()
        
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
        
        struct Editing {
            var isEditing: Bool = false {
                didSet {
                    if isEditing == true { opacity = 0.8 }
                    else { opacity = 1 }
                }
            }
            
            var opacity: CGFloat = 1
            
            var animation: Animation {
                if isEditing {
                    return Animation.easeInOut(duration: 1)
                        .repeatForever()
                } else {
                    return Animation.easeInOut
                }
            }
        }
    }
}
