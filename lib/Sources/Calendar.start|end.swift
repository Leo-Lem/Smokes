// Created by Leopold Lemmermann on 01.04.23.

import Foundation

public extension Calendar {
  func endOfDay(for date: Date) -> Date { startOfDay(for: date + 86400) - 1 }

  func start(of component: Calendar.Component, for date: Date) -> Date? {
    range(of: .day, in: component, for: date)
      .flatMap { self.date(bySetting: .day, value: $0.lowerBound, of: startOfDay(for: date) ) }
  }
  
  func end(of component: Calendar.Component, for date: Date) -> Date? {
    range(of: .day, in: component, for: date)
      .flatMap { self.date(bySetting: .day, value: $0.upperBound, of: endOfDay(for: date) ) }
  }
}
