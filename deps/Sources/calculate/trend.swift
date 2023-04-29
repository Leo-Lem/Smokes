// Created by Leopold Lemmermann on 29.04.23.

import struct Foundation.Date
import enum SmokesModels.Interval
import enum SmokesModels.Subdivision

extension Calculate {
  static func trend(interval: Interval, subdivision: Subdivision, entries: [Date]) -> Double? {
    guard let intervals = interval.enumerate(by: subdivision) else { return nil }
    guard intervals.count > 1 else { return .infinity }

    return intervals.dropFirst()
      .reduce(into: (trend: 0.0, previous: liveValue.amount(intervals[0], entries))) { result, interval in
        let amount = liveValue.amount(interval, entries)
        result = (result.trend + Double(amount - result.previous), amount)
      }.trend
      / Double(intervals.count - 1)
  }
}
