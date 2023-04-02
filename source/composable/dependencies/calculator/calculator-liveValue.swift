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
    (entries.firstIndex { interval.dateInterval.end - 1 < $0 } ?? entries.endIndex) -
    (entries.firstIndex { interval.dateInterval.start <= $0 } ?? entries.endIndex)
  }
  
  private static func average(_ amount: Int, _ interval: Interval, _ subdivision: Subdivision) -> Double {
    guard let length = interval.count(by: subdivision, onlyComplete: true) else { return .infinity }
    return Double(amount) / Double(length == 0 ? 1 : length)
  }
  
  private static func trend(_ amounts: [Interval: Int], _ interval: Interval, _ subdivision: Subdivision) -> Double {
    let amounts = interval.enumerate(by: subdivision)?.map { amounts[$0] ?? 0 } ?? []
    
    var trend = 0.0
    
    if amounts.count > 1 {
      for i in 1 ..< amounts.count { trend += Double(amounts[i] - amounts[i - 1]) }
      trend /= Double(amounts.count - 1)
    }
    
    return trend
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
    
    return entries.reduce(
      (previousDate: first, longestInterval: TimeInterval.zero)
    ) { result, date in
      (previousDate: date, longestInterval: max(result.longestInterval, date.timeIntervalSince(result.previousDate)))
    }.longestInterval
  }
  
  private static func averageTimeBetween(_ amount: Int, _ interval: Interval) -> TimeInterval {
    amount == 0 ? .infinity : interval.dateInterval.duration / Double(amount)
  }
}
