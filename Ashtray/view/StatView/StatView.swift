//
//  StatView.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI

struct StatView: View {
    @EnvironmentObject var sc: StateController
    
    var body: some View { Content(startDate: sc.preferences.startDate, calc: calc) }
    
    private func calc(_ average: Average) -> Double { sc.calculate(average: average) }
    
    typealias Average = StateController.Average
}

//MARK: - Labels for the displayed averages
extension StateController.Average {
    static func statCases(_ date: Date, _ timespan: Timespan) -> [Self] {
        [
            Self(kind: (timespan, .daily), date: date),
            Self(kind: (timespan, .weekly), date: date),
            Self(kind: (timespan, .monthly), date: date)
        ]
    }
    
    var intervalName: String {
        switch self.kind.1 {
        case .daily: return "stat-daily-label"~
        case .weekly: return "stat-weekly-label"~
        case .monthly: return "stat-monthly-label"~
        }
    }
    
    static var timespanCases: [Timespan] = [.alltime, .thismonth, .thisweek] //TODO: add this year
    
    static func timespanName(_ timespan: Timespan) -> String {
        switch timespan {
        case .thisweek: return "stat-this-week-label"~
        case .thismonth: return "stat-this-month-label"~
        case .alltime: return "stat-alltime-label"~
        }
    }
}
