// Created by Leopold Lemmermann on 04.03.23.

import Foundation

extension Array where Element == Date {
  init(sortedDates count: Int) {
    self.init((0..<count).map { _ in Date.now + Double.random(in: -100_000_000..<100_000_000) }.sorted())
  }
}

extension DateInterval {
  static let example = Calendar.current.dateInterval(of: .month, for: .now)!
}
