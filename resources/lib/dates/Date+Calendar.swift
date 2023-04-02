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
}

extension Calendar {
  func endOfDay(for date: Date) -> Date { startOfDay(for: date + 86400) - 1 }
}
