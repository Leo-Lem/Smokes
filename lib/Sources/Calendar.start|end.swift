// Created by Leopold Lemmermann on 01.04.23.

import Foundation

public extension Calendar {
  func endOfDay(for date: Date) -> Date { startOfDay(for: date + 86400) - 1 }
  
  func start(of component: Calendar.Component, for date: Date) -> Date? {
    range(of: smaller(component), in: component, for: date)
      .flatMap { self.date(bySetting: smaller(component), value: $0.lowerBound, of: startOfDay(for: date)) }
  }
  
  func end(of component: Calendar.Component, for date: Date) -> Date? {
    range(of: smaller(component), in: component, for: date)
      .flatMap { self.date(bySetting: smaller(component), value: $0.upperBound-1, of: endOfDay(for: date)) }
  }
  
  private func smaller(_ component: Calendar.Component) -> Calendar.Component {
    switch component {
    case .day, .hour, .minute, .second: return .nanosecond
    case .weekOfYear, .weekOfMonth: return .weekday
    case .year: return .month
    default: return .day
    }
  }
}
