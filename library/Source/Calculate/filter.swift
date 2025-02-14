// Created by Leopold Lemmermann on 29.04.23.

import struct Foundation.Date
import enum Types.Interval

extension Calculate {
  static func filter(interval: Interval, entries: [Date]) -> [Date] {
    guard entries.count > 0 else { return [] }

    let startIndex = interval.start.flatMap { start in entries.firstIndex { start <= $0 } } ?? entries.startIndex
    let endIndex = interval.end.flatMap { end in entries.firstIndex { end < $0 } } ?? entries.endIndex

    return Array(entries[startIndex ..< endIndex])
  }
}
