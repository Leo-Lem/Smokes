// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import SwiftUI

extension DashboardView {
  enum AmountOption: String, ConfigurableWidgetOption {
    case yesterday = "YESTERDAY", week = "THIS_WEEK", month = "THIS_MONTH", year = "THIS_YEAR"
    
    var interval: Interval {
      switch self {
      case .yesterday: return .day(.yesterday)
      case .week: return .week(.today)
      case .month: return .month(.today)
      case .year: return .year(.today)
      }
    }
  }
  
  enum TimeOption: String, ConfigurableWidgetOption {
    case sinceLast = "SINCE_LAST_SMOKE", longestBreak = "LONGEST_SMOKE_BREAK"
  }
}
