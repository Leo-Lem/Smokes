// Created by Leopold Lemmermann on 01.04.23.

import Dependencies
import Foundation

extension DateInterval {
  @Dependency(\.calendar) private static var cal: Calendar
  @Dependency(\.date.now) private static var now: Date

  static var day: DateInterval { day(of: now) }
  static var week: DateInterval { week(of: now) }
  static var month: DateInterval { month(of: now) }
  static var year: DateInterval { year(of: now) }
  static var yesterday: DateInterval { day(of: cal.date(byAdding: .day, value: -1, to: now)!) }
  static var untilEndOfDay: DateInterval { untilEndOfDay(of: now) }

  static func day(of date: Date) -> DateInterval { cal.dateInterval(of: .day, for: date)! }
  static func week(of date: Date) -> DateInterval { cal.dateInterval(of: .weekOfYear, for: date)! }
  static func month(of date: Date) -> DateInterval { cal.dateInterval(of: .month, for: date)! }
  static func year(of date: Date) -> DateInterval { cal.dateInterval(of: .year, for: date)! }
  static func untilEndOfDay(of date: Date) -> DateInterval {
    DateInterval(start: .distantPast, end: cal.endOfDay(for: now))
  }
}
