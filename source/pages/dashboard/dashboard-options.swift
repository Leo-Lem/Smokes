// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import SwiftUI

extension DashboardView {
  enum IntervalOption: String, ConfigurableWidgetOption {
    case yesterday = "YESTERDAY", week = "THIS_WEEK", month = "THIS_MONTH", year = "THIS_YEAR"
    
    var interval: DateInterval {
      switch self {
      case .yesterday: return .yesterday
      case .week: return .week
      case .month: return .month
      case .year: return .year
      }
    }
  }
  
  enum TimeOption: String, ConfigurableWidgetOption {
    case sinceLast = "SINCE_LAST_SMOKE", longestBreak = "LONGEST_SMOKE_BREAK"
  }
}
