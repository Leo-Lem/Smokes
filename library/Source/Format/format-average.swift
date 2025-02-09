// Created by Leopold Lemmermann on 29.04.23.

import SwiftUI
import enum Generated.L10n

extension Format {
  static func average(_ average: Double) -> Text {
    guard average != .infinity else { return Text(L10n.Placeholder.data) }

    let rounded = (average * 100).rounded() / 100

    return Text("\(L10n.Smokes.valueLf(Float(rounded))) \(L10n.Smokes.labelLld(Int(rounded)))").font(.headline)
  }
}
