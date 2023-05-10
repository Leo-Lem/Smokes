// Created by Leopold Lemmermann on 29.04.23.

import Dependencies
import Foundation
import func SmokesLibrary.memoize
import SmokesModels

public extension DependencyValues {
  var calculate: Calculate {
    get { self[Calculate.self] }
    set { self[Calculate.self] = newValue }
  }
}

@MainActor
public struct Calculate {
  public var filter: (Interval, [Date]) -> [Date]

  public var amounts: (Interval, Subdivision, [Date]) -> [Interval: Int]?

  public var amount: (Interval, [Date]) -> Int
  public var average: (Interval, Subdivision, [Date]) -> Double?
  public var trend: (Interval, Subdivision, [Date]) -> Double?

  public var `break`: (Date, [Date]) -> TimeInterval
  public var longestBreak: (Date, [Date]) -> TimeInterval
  public var averageBreak: (Interval, [Date]) -> TimeInterval
}

extension Calculate: DependencyKey {
  public static var liveValue = Calculate(
    filter: Self.filter,
    amounts: Self.amounts,
    amount: memoize(Self.amount),
    average: Self.average,
    trend: Self.trend,
    break: Self.break,
    longestBreak: Self.longestBreak,
    averageBreak: Self.averageBreak
  )

  #if DEBUG
  public static var previewValue = Calculate(
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
