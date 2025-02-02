// Created by Leopold Lemmermann on 01.04.23.

import Dependencies
import Types
import SwiftUI

public extension DependencyValues {
  var format: Format {
    get { self[Format.self] }
    set { self[Format.self] = newValue }
  }
}

public struct Format: @unchecked Sendable {
  public var amount: (Int) -> Text
  public var average: (Double) -> Text
  public var trend: (Double) -> Text
  public var time: (TimeInterval) -> Text
  public var plotInterval: (Interval, Interval, Subdivision) -> String?

  public func amount(_ amount: Int?) -> Text? { amount.flatMap(self.amount) }
  public func average(_ average: Double?) -> Text? { average.flatMap(self.average) }
  public func trend(_ trend: Double?) -> Text? { trend.flatMap(self.trend) }
  public func time(_ time: TimeInterval?) -> Text? { time.flatMap(self.time) }
  public func plotInterval(_ plotInterval: Interval?, bounds: Interval, sub: Subdivision) -> String? {
    plotInterval.flatMap { self.plotInterval($0, bounds, sub) }
  }
}

extension Format: DependencyKey {
  public static let liveValue = Format(
    amount: Self.amount,
    average: Self.average,
    trend: Self.trend,
    time: Self.time,
    plotInterval: Self.plotInterval
  )

  #if DEBUG
  public static let previewValue = Self.liveValue
  #endif
}
