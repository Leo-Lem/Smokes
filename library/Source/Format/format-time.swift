// Created by Leopold Lemmermann on 29.04.23.

import typealias Foundation.TimeInterval
import SwiftUI
import enum Generated.L10n

@available(iOS 16, *)
extension Format {
  static func time(time: TimeInterval) -> Text {
    guard time.isFinite else { return Text(L10n.Placeholder.data) }

    let formatter = DateComponentsFormatter()
    formatter.maximumUnitCount = 1
    formatter.unitsStyle = .full
    return Text(formatter.string(from: time) ?? "")
  }
}
