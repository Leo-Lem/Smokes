// Created by Leopold Lemmermann on 29.04.23.

import SwiftUI
import enum Generated.L10n

extension Format {
  static func trend(_ trend: Double) -> Text {
    guard trend != .infinity else { return Text(L10n.Placeholder.data) }

    return Text(trend >= 0 ? "+" : "") + average(trend)
  }
}
