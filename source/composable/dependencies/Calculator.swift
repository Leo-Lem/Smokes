// Created by Leopold Lemmermann on 26.03.23.

import Dependencies
import Foundation

extension DependencyValues {
  var calculator: Calculator {
    get { self[Calculator.self] }
    set { self[Calculator.self] = newValue }
  }
}

struct Calculator {
  var amount: (_ entries: [Date], _ interval: DateInterval) -> Int
  
  var average: (_ amount: Int, _ interval: DateInterval, _ subdivision: Calendar.Component) -> Double
  
  var subdivide: (
    _ amounts: [DateInterval: Int], _ interval: DateInterval, _ subdivision: Calendar.Component
  ) -> [DateInterval: Int]
  
  var trend: (_ amounts: [Int]) -> Double
  
  var timeSinceLast: (_ entries: [Date], _ date: Date) -> TimeInterval
  
  var longestBreak: (_ entries: [Date]) -> TimeInterval
  
  var averageTimeBetween: (_ amount: Int, _ interval: DateInterval) -> TimeInterval
}

extension Calculator: DependencyKey {
  static var liveValue: Self {
    @Dependency(\.calendar) var cal: Calendar
    
    func amount(_ entries: [Date], _ interval: DateInterval) -> Int {
      (entries.firstIndex { interval.end - 1 < $0 } ?? entries.endIndex) -
        (entries.firstIndex { interval.start <= $0 } ?? entries.endIndex)
    }
    
    func average(_ amount: Int, _ interval: DateInterval, _ subdivision: Calendar.Component) -> Double {
      guard
        let length = cal.dateComponents([subdivision], from: interval.start, to: interval.end).value(for: subdivision)
      else { return .infinity }
      
      return Double(amount) / Double(length == 0 ? 1 : length)
    }
    
    func subdivide(
      _ amounts: [DateInterval: Int], _ interval: DateInterval, _ subdivision: Calendar.Component
    ) -> [DateInterval: Int] {
      var subintervals = [DateInterval](), date = cal.startOfDay(for: interval.start)
      
      while date < interval.end {
        let nextDate = cal.date(byAdding: subdivision, value: 1, to: date)!
        let interval = DateInterval(start: date, end: nextDate)
        if amounts.keys.contains(interval) { subintervals.append(interval) }
        date = nextDate
      }
      
      return .init(uniqueKeysWithValues: subintervals.map { ($0, amounts[$0]!) })
    }
    
    func trend(_ amounts: [Int]) -> Double {
      var trend = 0.0
      
      if amounts.count > 1 {
        for i in 1..<amounts.count { trend += Double(amounts[i] - amounts[i - 1]) }
        trend /= Double(amounts.count - 1)
      }
      
      return trend
    }
    
    func timeSinceLast(_ entries: [Date], _ date: Date) -> TimeInterval {
      entries
        .last { $0 < date }
        .flatMap { DateInterval(start: $0, safeEnd: date) }.optional?
        .duration
      ?? .infinity
    }
    
    func longestBreak(_ entries: [Date]) -> TimeInterval {
      guard let first = entries.first else { return .infinity }
      
      return entries.reduce(
        (previousDate: first, longestInterval: TimeInterval.zero)
      ) { result, date in
        (previousDate: date, longestInterval: max(result.longestInterval, date.timeIntervalSince(result.previousDate)))
      }.longestInterval
    }
    
    func averageTimeBetween(_ amount: Int, _ interval: DateInterval) -> TimeInterval {
      amount == 0 ? .infinity : interval.duration / Double(amount)
    }
    
    return Self(
      amount: amount,
      average: average,
      subdivide: subdivide,
      trend: trend,
      timeSinceLast: timeSinceLast,
      longestBreak: longestBreak,
      averageTimeBetween: averageTimeBetween
    )
  }
}

extension Calculator {
  static let testValue = Self(
    amount: unimplemented("Calculator.amount"),
    average: unimplemented("Calculator.average"),
    subdivide: unimplemented("Calculator.subdivide"),
    trend: unimplemented("Calculator.trend"),
    timeSinceLast: unimplemented("Calculator.timeSinceLast"),
    longestBreak: unimplemented("Calculator.longestBreak"),
    averageTimeBetween: unimplemented("Calculator.averageTimeBetween")
  )
}

extension Calculator {
  static let previewValue = Self(
    amount: { _, _ in Int.random(in: 0..<999) },
    average: { _, _, _ in Double.random(in: 0..<999) },
    subdivide: { amounts, _, _ in amounts },
    trend: { _ in Double.random(in: 0..<999) },
    timeSinceLast: { _, _ in Double.random(in: 0..<999_999) },
    longestBreak: { _ in Double.random(in: 0..<999_999) },
    averageTimeBetween: { _, _ in Double.random(in: 0..<999_999) }
  )
}
