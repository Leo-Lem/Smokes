// Created by Leopold Lemmermann on 28.04.23.

import struct Foundation.Date
import struct Foundation.TimeInterval

extension Calculate {
  func filter(interval: Interval, entries: [Date]) -> [Date] {
    guard entries.count > 0 else { return [] }

    let startIndex = interval.start.flatMap { start in entries.firstIndex { start <= $0 } } ?? entries.startIndex
    let endIndex = interval.end.flatMap { end in entries.firstIndex { end < $0 } } ?? entries.endIndex
      
    return Array(entries[startIndex ..< endIndex])
  }
  
  func filterAmounts(parameters: IntervalAndSubdivision, amounts: [Interval: Int]) -> [Interval: Int]? {
    guard let intervals = parameters.interval.enumerate(by: parameters.subdivision) else { return nil }
    return Dictionary(uniqueKeysWithValues: intervals.map { ($0, amounts[$0, default: 0]) })
  }
  
  func amount(interval: Interval, entries: [Date]) -> Int {
    guard entries.count > 0 else { return 0 }

    return (interval.end.flatMap { end in entries.firstIndex { end < $0 } } ?? entries.endIndex)
      - (interval.start.flatMap { start in entries.firstIndex { start <= $0 } } ?? entries.startIndex)
  }
  
  func average(parameters: IntervalAndSubdivision, amounts: [Interval: Int]) -> Double? {
    guard
      let amount = amounts[parameters.interval],
      let length = parameters.interval.count(by: parameters.subdivision)
    else { return nil }
      
    guard length > 0 else { return .infinity }

    // +1 because fractions should be counted too
    return Double(amount) / Double(length + 1)
  }
    
  func trend(parameters: IntervalAndSubdivision, amounts: [Interval: Int]) -> Double? {
    guard !amounts.isEmpty else { return nil }
    
    guard
      let intervals = parameters.interval.enumerate(by: parameters.subdivision),
      intervals.count > 1
    else { return .infinity }

    return intervals.dropFirst()
      .reduce(into: (trend: 0.0, previous: amounts[intervals.first!] ?? 0)) { result, interval in
        let amount = amounts[interval] ?? 0
        result = (result.trend + Double(amount - result.previous), amount)
      }.trend
      / Double(intervals.count - 1)
  }
  
  func averageBreak(interval: Interval, amounts: [Interval: Int]) -> TimeInterval? {
    guard let amount = amounts[interval] else { return nil }
    guard amount > 1 else { return .infinity }
    
    return interval.duration / Double(amount)
  }
}
