// Created by Leopold Lemmermann on 01.04.23.

import Foundation

public extension Calendar {
  func endOfDay(for date: Date) -> Date { startOfDay(for: date + 86400) - 1 }
  
  func start(of component: Calendar.Component, for date: Date) -> Date? {
    range(of: smaller(component), in: component, for: date)
      .flatMap { self.date(bySetting: smaller(component), value: $0.lowerBound, of: startOfDay(for: date)) }
  }
  
  func end(of component: Calendar.Component, for date: Date) -> Date? {
    guard
      let next = self.date(byAdding: component, value: 1, to: date),
      let startOfNext = start(of: component, for: next)
    else { return nil }
    
    return startOfNext - 1
  }
  
  private func smaller(_ component: Calendar.Component) -> Calendar.Component {
    switch component {
    case .weekOfYear, .weekOfMonth: return .weekday
    case .month: return .day
    case .year: return .month
    default: return .second
    }
  }
}
