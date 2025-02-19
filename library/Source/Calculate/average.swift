// Created by Leopold Lemmermann on 29.04.23.

import struct Foundation.Date
import Types

extension Calculate {
  static func average(interval: Interval, subdivision: Subdivision, entries: [Date]) -> Double? {
    guard let length = interval.count(by: subdivision) else { return nil }
    guard length > 0 else { return .infinity }
    guard length < .max else { return 0 }

    // +1 because fractions should be counted too
    return Double(liveValue.amount(interval, entries)) / Double(length + 1)
  }
}
