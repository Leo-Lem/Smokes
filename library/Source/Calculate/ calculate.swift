// Created by Leopold Lemmermann on 29.04.23.

import Dependencies
import Foundation
import Types

public extension DependencyValues {
  var calculate: Calculate {
    get { self[Calculate.self] }
    set { self[Calculate.self] = newValue }
  }
}

public struct Calculate: Sendable {
  public var filter: @Sendable (Interval, [Date]) -> [Date]

  public var amounts: @Sendable (Interval, Subdivision, [Date]) -> [Interval: Int]?

  public var amount: @Sendable (Interval, [Date]) -> Int
  public var average: @Sendable (Interval, Subdivision, [Date]) -> Double?
  public var trend: @Sendable (Interval, Subdivision, [Date]) -> Double?

  public var `break`: @Sendable (Date, [Date]) -> TimeInterval
  public var longestBreak: @Sendable (Date, [Date]) -> TimeInterval
  public var averageBreak: @Sendable (Interval, [Date]) -> TimeInterval
}

extension Calculate: DependencyKey {
  public static let liveValue = Calculate(
    filter: Self.filter,
    amounts: Self.amounts,
    amount: Self.amount,
    average: Self.average,
    trend: Self.trend,
    break: Self.break,
    longestBreak: Self.longestBreak,
    averageBreak: Self.averageBreak
  )

  #if DEBUG
  public static let previewValue = Calculate(
    filter: { $1 },
    amounts: { _, _, _ in
      Dictionary(
        uniqueKeysWithValues: (-50..<50)
          .map { Interval.day(Date(timeIntervalSinceNow: TimeInterval($0) * 86400)) }
          .map { ($0, Int.random(in: 0..<999)) }
      )
    },
    amount: { _, _ in .random(in: 0..<999) },
    average: { _, _, _ in .random(in: 0..<999) },
    trend: { _, _, _ in .random(in: 0..<999) },
    break: { _, _ in .random(in: 0..<999_999_999) },
    longestBreak: { _, _ in .random(in: 0..<999_999_999) },
    averageBreak: { _, _ in .random(in: 0..<999_999_999) }
  )
  #endif
}
