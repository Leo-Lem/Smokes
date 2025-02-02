// Created by Leopold Lemmermann on 29.04.23.

import struct Foundation.Date
import struct Foundation.TimeInterval
import Types

extension Calculate {
  static func `break`(date: Date, entries: [Date]) -> TimeInterval {
    guard let previous = entries.last(where: { $0 < date }) else { return .infinity }

    return previous.distance(to: date)
  }

  static func longestBreak(date: Date, entries: [Date]) -> TimeInterval {
    guard let first = entries.first else { return .infinity }
    guard entries.count > 1 else { return date.timeIntervalSince(first) }

    return entries.reduce((previousDate: first, longest: TimeInterval.zero)) { result, date in
      (date, max(result.longest, date.timeIntervalSince(result.previousDate)))
    }.longest
  }

  static func averageBreak(interval: Interval, entries: [Date]) -> TimeInterval {
    let amount = liveValue.amount(interval, entries)

    guard amount > 1 else { return .infinity }

    return interval.duration / Double(amount)
  }
}
