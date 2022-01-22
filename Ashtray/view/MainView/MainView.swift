//
//  AshtrayView.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 17.01.22.
//

import SwiftUI
import MyCustomUI

struct MainView: View {
    @EnvironmentObject private var sc: StateController
    
    var body: some View { Content(calc: calc, add: add, rem: rem) }
    
    private func add() { try? sc.add(1, on: Date()) }
    private func rem() { try? sc.add(-1, on: Date()) }
    private func calc(_ total: Total) -> Int { sc.calculate(total: total) }
    
    typealias Total = StateController.Total
}


//MARK: - Labels for the different displayed counts
extension StateController.Total {
    static var mainCases: [Self] = [
        Self(kind: .thisday, date: Date()),
        Self(kind: .thisday, date: Date() - TimeInterval(1, unit: .day)),
        Self(kind: .thisweek, date: Date()),
        Self(kind: .thismonth, date: Date()),
        Self(kind: .alltime, date: Date())
    ]
    
    var mainName: String {
        switch self.kind {
        case .thisday:
            if Calendar.current.isDate(Date(), inSameDayAs: self.date) {
                return "main-today-label"~
            } else if Calendar.current.isDate(Date() - TimeInterval(1, unit: .day), inSameDayAs: self.date) {
                return "main-yesterday-label"~
            } else { return "main-unknown-label"~ }
        case .thisweek: return "main-this-week-label"~
        case .thismonth: return "main-this-month-label"~
        case .alltime: return "main-alltime-label"~
        }
    }
}
