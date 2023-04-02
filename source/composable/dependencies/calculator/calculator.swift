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
  var amount: (_ entries: [Date], _ interval: Interval) -> Int
  var average: (_ amount: Int, _ interval: Interval, _ subdivision: Subdivision) -> Double
  var trend: (_ amounts: [Interval: Int], _ interval: Interval, _ subdivision: Subdivision) -> Double
  
  var sinceLast: (_ entries: [Date], _ date: Date) -> TimeInterval
  var longestBreak: (_ entries: [Date]) -> TimeInterval
  var averageTimeBetween: (_ amount: Int, _ interval: Interval) -> TimeInterval
}
