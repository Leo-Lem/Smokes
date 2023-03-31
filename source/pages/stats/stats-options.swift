// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import SwiftUI

extension StatsView {
  enum AverageOption: String, ConfigurableWidgetOption {
    case perday = "PER_DAY", perweek = "PER_WEEK", permonth = "PER_MONTH", peryear = "PER_YEAR"
    
    var comp: Calendar.Component {
      switch self {
      case .perday: return .day
      case .perweek: return .weekOfYear
      case .permonth: return .month
      case .peryear: return .year
      }
    }
    
    var grouping: Date.FormatStyle {
      switch self {
      case .perday: return .init().day(.defaultDigits)
      case .perweek: return .init().week(.twoDigits)
      case .permonth: return .init().month(.abbreviated)
      case .peryear: return .init().year(.twoDigits)
      }
    }
    
    func domain(_ interval: DateInterval) -> [String] {
      interval.start.enumerate(until: interval.end, by: .day)
        .reduce(into: [String]()) { result, next in
          let grouped = next.formatted(grouping)
          if !result.contains(grouped) { result.append(grouped) }
        }
    }
    
    var xLabel: LocalizedStringKey {
      switch self {
      case .perday: return "DAY"
      case .perweek: return "WEEK"
      case .permonth: return "MONTH"
      case .peryear: return "YEAR"
      }
    }
    
    func groups(from data: [Date]) -> [String] {
      data.reduce(into: [String]()) { result, next in
        let next = next.formatted(grouping)
        if !result.contains(next) { result.append(next) }
      }
    }
    
    func amount(from data: [Date], for group: String) -> Int {
      if
        let last = data.lastIndex(where: { $0.formatted(grouping) == group }),
        let first = data.firstIndex(where: { $0.formatted(grouping) == group })
      {
        return 1 + last - first
      } else { return 0 }
    }
  }
}
