//
//  StatView.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI

struct StatView: View {
    @EnvironmentObject var sc: StateController
    
    var body: some View {
        Content()
    }
    
    typealias Timespan = StateController.Average.Timespan
    typealias Interval = StateController.Average.Interval
}

//MARK: - Labels for the displayed averages
extension StateController.Average.Timespan: CaseIterable {
    static var allCases: [Self] = [.thisweek, .thismonth, .alltime]
    
    var name: String {
        switch self {
        case .thisweek: return "This Week"
        case .thismonth: return "This Month"
        case .alltime: return "All Time"
        }
    }
}

extension StateController.Average.Interval: CaseIterable {
    static var allCases: [Self] = [.daily, .weekly, .monthly]
    
    var name: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        }
    }
}
