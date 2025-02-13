// Created by Leopold Lemmermann on 11.02.25.

import Types

public extension Interval {
  func formatted<S>(_ format: S) -> S.FormatOutput where Self == S.FormatInput, S: FormatStyle { format.format(self) }
}

public extension FormatStyle where Self == IntervalFormatStyle {
  static func interval(bounds: Interval, subdivision: Subdivision) -> Self {
    IntervalFormatStyle(bounds: bounds, subdivision: subdivision)
  }
}

public struct IntervalFormatStyle: FormatStyle, Sendable {
  let bounds: Interval, subdivision: Subdivision

  public init(bounds: Interval, subdivision: Subdivision) {
    self.bounds = bounds
    self.subdivision = subdivision
  }

  public func format(_ interval: Interval) -> String {
    guard let date = interval.end else { return "" }

    let style: Date.FormatStyle = switch (bounds, subdivision) {
      case (.week, .day): .init().weekday(.abbreviated)
      case (.month, .day): .init().day(.twoDigits)
      case (.month, .week): .init().week(.weekOfMonth)
      case (.year, .week): .init().week(.twoDigits)
      case (.year, .month): .init().month(.abbreviated)
      case (_, .day): .init().day(.twoDigits).month(.abbreviated).year(.defaultDigits)
      case (_, .week): .init().week(.twoDigits).year(.defaultDigits)
      case (_, .month): .init().month(.abbreviated).year(.defaultDigits)
      case (_, .year): .init().year(.defaultDigits)
      }

    return date.formatted(style)
  }
}
