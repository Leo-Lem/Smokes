// Created by Leopold Lemmermann on 02.04.23.

import Dependencies
import Foundation

extension Calculator: DependencyKey {
  static var liveValue = Self(
    amount: amount, average: average, trend: trend,
    sinceLast: sinceLast, longestBreak: longestBreak, averageTimeBetween: averageTimeBetween
  )
  
  @Dependency(\.calendar) private static var cal: Calendar
  
  private static func amount(_ entries: [Date], _ interval: Interval) -> Int {
    (entries.firstIndex { interval.dateInterval.end < $0 } ?? entries.endIndex) -
      (entries.firstIndex { interval.dateInterval.start <= $0 } ?? entries.endIndex)
  }
  
  private static func average(_ amount: Int, _ interval: Interval, _ subdivision: Subdivision) -> Double {
    guard
      let length = interval.count(by: subdivision),
      length > 0
    else { return .infinity }
    
    return Double(amount) / Double(length)
  }
  
  private static func trend(_ amounts: [Interval: Int], _ interval: Interval, _ subdivision: Subdivision) -> Double {
    guard
      amounts.count > 0,
      let intervals = interval.enumerate(by: subdivision),
      intervals.count > 1
    else { return .infinity }
    
    return intervals.dropFirst()
      .reduce(into: (trend: 0.0, previous: amounts[intervals.first!] ?? 0)) { result, interval in
        let amount = amounts[interval] ?? 0
        result = (result.trend + Double(amount - result.previous), amount)
      }.trend
    / Double(intervals.count - 1)
  }
  
  private static func sinceLast(_ entries: [Date], _ date: Date) -> TimeInterval {
    entries
      .last { $0 < date }
      .flatMap { DateInterval(start: $0, safeEnd: date) }.optional?
      .duration
      ?? .infinity
  }
  
  private static func longestBreak(_ entries: [Date]) -> TimeInterval {
    guard let first = entries.first else { return .infinity }
    
    if entries.count == 1 {
      @Dependency(\.date.now) var now: Date
      return first.distance(to: now)
    }
    
    return entries.reduce(
      (previousDate: first, longestInterval: TimeInterval.zero)
    ) { result, date in
      (previousDate: date, longestInterval: max(result.longestInterval, date.timeIntervalSince(result.previousDate)))
    }.longestInterval
  }
  
  private static func averageTimeBetween(_ amount: Int, _ interval: Interval) -> TimeInterval {
    guard amount > 1 else { return .infinity }
    
    return interval.dateInterval.duration / Double(amount)
  }
}
