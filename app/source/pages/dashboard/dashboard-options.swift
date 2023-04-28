// Created by Leopold Lemmermann on 01.04.23.

import SwiftUI

extension DashboardView {
  enum AmountOption: String, ConfigurableWidgetOption {
    case yesterday = "YESTERDAY", week = "THIS_WEEK", month = "THIS_MONTH", year = "THIS_YEAR"
    
    var interval: Interval {
      @Dependency(\.calendar) var cal
      @Dependency(\.date.now) var now
      
      switch self {
      case .yesterday: return .day(cal.startOfDay(for: now) - 1)
      case .week: return .week(now)
      case .month: return .month(now)
      case .year: return .year(now)
      }
    }
  }
  
  enum TimeOption: String, ConfigurableWidgetOption {
    case sinceLast = "SINCE_LAST_SMOKE", longestBreak = "LONGEST_SMOKE_BREAK"
  }
}
