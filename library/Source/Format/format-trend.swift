// Created by Leopold Lemmermann on 29.04.23.

import SwiftUI

extension Format {
  static func trend(_ trend: Double) -> Text {
    guard trend != .infinity else { return Text("No data", comment: "Placeholder when no data is available.") }

    return Text(trend >= 0 ? "+" : "") + average(trend)
  }
}
