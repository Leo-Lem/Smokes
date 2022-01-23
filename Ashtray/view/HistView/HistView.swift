//
//  HistVIew.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI

struct HistView: View {
    @EnvironmentObject private var sc: StateController
    
    var body: some View {
        Content(startDate: sc.preferences.startDate, calc: calc, add: add, rem: rem)
    }
    
    private func add(_ date: Date) { try? sc.add(1, on: date) }
    private func rem(_ date: Date) { try? sc.add(-1, on: date) }
    
    private func calc(_ date: Date) async -> [Total: Int] {
        var amounts = [Total: Int]()
        
        for total in Total.histCases(date) {
            amounts[total] = await sc.calculate(total: total)
        }
        
        return amounts
    }
    
    typealias Total = StateController.Total
}

//MARK: - Labels for the different displayed counts
extension StateController.Total {
    static func histCases(_ date: Date) -> [Self] {
        [
            Self(kind: .thisday, date: date),
            Self(kind: .thisweek, date: date),
            Self(kind: .thismonth, date: date),
            Self(kind: .alltime, date: date)
        ]
    }
    
    var histName: String {
        switch self.kind {
        case .thisday: return "hist-this-day-label"~
        case .thisweek: return "hist-this-week-label"~
        case .thismonth: return "hist-this-month-label"~
        case .alltime: return "hist-alltime-label"~
        }
    }
}
