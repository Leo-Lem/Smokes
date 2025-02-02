// Created by Leopold Lemmermann on 30.04.23.

import Foundation
import Types

extension Format {
  static func plotInterval(_ plotInterval: Interval, bounds: Interval, subdivision: Subdivision) -> String? {
    guard let date = plotInterval.end else { return nil }

    return date.formatted(plotLabelFormatting(bounds, subdivision))
  }

  private static func plotLabelFormatting(_ bounds: Interval, _ subdivision: Subdivision) -> Date.FormatStyle {
    switch (bounds, subdivision) {
    case (.week, .day): return .init().weekday(.abbreviated)
    case (.month, .day): return .init().day(.twoDigits)
    case (.month, .week): return .init().week(.weekOfMonth)
    case (.year, .day): return .init().day(.twoDigits).month(.twoDigits)
    case (.year, .week): return .init().week(.twoDigits)
    case (.year, .month): return .init().month(.abbreviated)
    case (_, .day): return .init().day(.twoDigits).month(.abbreviated).year(.defaultDigits)
    case (_, .week): return .init().week(.twoDigits).year(.defaultDigits)
    case (_, .month): return .init().month(.abbreviated).year(.defaultDigits)
    case (_, .year): return .init().year(.defaultDigits)
    }
  }
}
