// Created by Leopold Lemmermann on 29.04.23.

import SwiftUI

extension Format {
  static func average(_ average: Double) -> Text {
    guard average != .infinity else { return Text("No data") }

    let rounded = (average * 100).rounded() / 100

    return Text("\(rounded, format: .number) smokes").font(.headline)
  }
}
