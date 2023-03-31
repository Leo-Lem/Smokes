// Created by Leopold Lemmermann on 01.04.23.

import Dependencies
import Foundation

extension Date {
  @Dependency(\.calendar) private static var cal: Calendar
  @Dependency(\.date.now) private static var now: Date
  
  static var today: Date { now }
  static var yesterday: Date { cal.date(byAdding: .day, value: -1, to: now)! }
  static var startOfToday: Date { cal.startOfDay(for: now) }
  static var startOfYesterday: Date { cal.startOfDay(for: yesterday) }
  static var endOfToday: Date { cal.endOfDay(for: now) }
  
  func enumerate(until date: Date, by component: Calendar.Component) -> [Date] {
    Array(stride(from: self, to: date, by: Self.cal.dateInterval(of: component, for: self)?.duration ?? 86400))
  }
}

extension Calendar {
  func endOfDay(for date: Date) -> Date {
    self.startOfDay(for: date + 86400) - 1
  }
}
