// Created by Leopold Lemmermann on 26.03.23.

import ComposableArchitecture
import Foundation

extension DependencyValues {
  var calculator: Calculator {
    get { self[Calculator.self] }
    set { self[Calculator.self] = newValue }
  }
}

struct Calculator {
  var average: (_ amount: Int?, _ interval: DateInterval, _ subdivision: Calendar.Component) -> Double?
  
  var subdivide: (
    _ amounts: [DateInterval: Int], _ interval: DateInterval, _ subdivision: Calendar.Component
  ) -> [DateInterval: Int]?
  
  var trend: (_ amounts: [Int]?) -> Double?
  
  var determineTimeSinceLast: (_ entries: [Date]?, _ date: Date) -> TimeInterval?
  
  var averageTimeBetween: (_ amount: Int?, _ interval: DateInterval) -> TimeInterval?
}

extension Calculator: DependencyKey {
  static var liveValue: Self {
    @Dependency(\.calendar) var cal: Calendar
    
    return Self { amount, interval, subdivision in
      guard
        let amount,
        let length = cal.dateComponents([subdivision], from: interval.start, to: interval.end).value(for: subdivision)
      else { return nil }
      
      return Double(amount) / Double(length == 0 ? 1 : length)
    } subdivide: { amounts, interval, subdivision in
      var subintervals = [DateInterval](), date = cal.startOfDay(for: interval.start)
      
      while date < interval.end {
        let nextDate = cal.date(byAdding: subdivision, value: 1, to: date)!
        let interval = DateInterval(start: date, end: nextDate)
        if amounts.keys.contains(interval) { subintervals.append(interval) }
        date = nextDate
      }
      
      guard !subintervals.isEmpty else { return nil }
      
      return .init(uniqueKeysWithValues: subintervals.map { ($0, amounts[$0]!) })
    } trend: { amounts in
      guard let amounts else { return nil }
      
      var trend = 0.0
      
      if amounts.count > 1 {
        for i in 1 ..< amounts.count { trend += Double(amounts[i] - amounts[i - 1]) }
        trend /= Double(amounts.count - 1)
      }
      
      return trend
    } determineTimeSinceLast: { entries, date in
      guard let entries else { return nil }
      
      return entries
        .last { $0 < date }
        .flatMap { DateInterval(start: $0, safeEnd: date) }.optional?
        .duration
      ?? .infinity
    } averageTimeBetween: { amount, interval in
      amount.flatMap { (interval.duration * 0.66) / Double($0) }
    }
  }
}

extension Calculator {
  static let testValue = Self(
    average: unimplemented("Calculator.average"),
    subdivide: unimplemented("Calculator.subdivide"),
    trend: unimplemented("Calculator.trend"),
    determineTimeSinceLast: unimplemented("Calculator.timeSinceLast"),
    averageTimeBetween: unimplemented("Calculator.averageTimeBetween")
  )
}

extension Calculator {
  static let previewValue = Self(
    average: { _, _, _ in Double.random(in: 0..<999)},
    subdivide: { _, _, _ in nil}, // TODO: provide some mock values
    trend: { _ in Double.random(in: 0..<999)},
    determineTimeSinceLast: { _, _ in Double.random(in: 0..<999_999) },
    averageTimeBetween: { _, _ in Double.random(in: 0..<999_999) }
  )
}
