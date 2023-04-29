// Created by Leopold Lemmermann on 29.04.23.

import struct Foundation.Date
import enum SmokesModels.Interval
import enum SmokesModels.Subdivision

extension Calculate {
  static func amount(interval: Interval, entries: [Date]) -> Int {
    guard entries.count > 0 else { return 0 }

    return (interval.end.flatMap { end in entries.firstIndex { end < $0 } } ?? entries.endIndex)
      - (interval.start.flatMap { start in entries.firstIndex { start <= $0 } } ?? entries.startIndex)
  }
  
  static func amounts(interval: Interval, subdivision: Subdivision, entries: [Date]) -> [Interval: Int]? {
    guard let intervals = interval.enumerate(by: subdivision) else { return nil }
    
    return Dictionary(uniqueKeysWithValues: intervals.map { ($0, liveValue.amount($0, entries)) })
  }
}
