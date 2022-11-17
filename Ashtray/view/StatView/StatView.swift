//  Created by Leopold Lemmermann on 20.01.22.

import SwiftUI

struct StatView: View {
  @EnvironmentObject private var sc: StateController
    
  var body: some View { Content(startDate: sc.preferences.startDate, calc: calc) }
    
  private func calc(_ date: Date, _ timespan: Average.Timespan) async -> [Average: Double] {
    var averages = [Average: Double]()
        
    for average in Average.statCases(date, timespan) {
      averages[average] = await sc.calculate(average: average)
    }
        
    return averages
  }
    
  typealias Average = StateController.Average
}

// MARK: - Labels for the displayed averages

extension StateController.Average {
  static func statCases(_ date: Date, _ timespan: Timespan) -> [Self] {
    [
      Self(kind: (timespan, .daily), date: date),
      Self(kind: (timespan, .weekly), date: date),
      Self(kind: (timespan, .monthly), date: date)
    ]
  }
    
  var intervalName: LocalizedStringKey {
    switch kind.1 {
    case .daily: return "STATS_DAILY"
    case .weekly: return "STATS_WEEKLY"
    case .monthly: return "STATS_MONTHLY"
    }
  }
    
  static var timespanCases: [Timespan] = [.thisweek, .thismonth, .alltime]
    
  static func timespanName(_ timespan: Timespan) -> LocalizedStringKey {
    switch timespan {
    case .thisweek: return "HISTORY_THISWEEK"
    case .thismonth: return "HISTORY_THISWEEK"
    case .alltime: return "HISTORY_ALLTIME"
    }
  }
}
