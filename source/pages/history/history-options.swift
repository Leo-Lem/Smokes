// Created by Leopold Lemmermann on 01.04.23.

import Dependencies
import SwiftUI

extension HistoryView {
  enum IntervalOption: String, ConfigurableWidgetOption {
    case week = "THIS_WEEK", month = "THIS_MONTH", year = "THIS_YEAR"
    
    func interval(_ date: Date) -> DateInterval {
      switch self {
      case .week: return .week(of: date)
      case .month: return .month(of: date)
      case .year: return .year(of: date)
      }
    }
    
    var grouping: Date.FormatStyle {
      switch self {
      case .week: return .init().weekday(.short)
      case .month: return .init().day(.defaultDigits)
      case .year: return .init().month(.abbreviated)
      }
    }
    
    func domain(_ date: Date) -> [String] {
      let interval = interval(date)
      return interval.start.enumerate(until: interval.end, by: .day)
        .reduce(into: [String]()) { result, next in
          let grouped = next.formatted(grouping)
          if !result.contains(grouped) { result.append(grouped) }
        }
    }
    
    var xLabel: LocalizedStringKey {
      switch self {
      case .week: return "WEEKDAY"
      case .month: return "DAY"
      case .year: return "MONTH"
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
