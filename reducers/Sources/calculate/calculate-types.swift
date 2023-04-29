// Created by Leopold Lemmermann on 28.04.23.

import struct Foundation.Date
import struct Foundation.TimeInterval

public extension Calculate {
  typealias Filter = Calculator<Interval, [Date], [Date]>
  typealias AmountsFilter = Calculator<IntervalAndSubdivision, [Interval: Int], [Interval: Int]>

  typealias Amounter = Calculator<Interval, [Date], Int>
  typealias Averager = Calculator<IntervalAndSubdivision, [Interval: Int], Double>
  typealias Trender = Averager

  typealias BreakAverager = Calculator<Interval, [Interval: Int], TimeInterval>
}
