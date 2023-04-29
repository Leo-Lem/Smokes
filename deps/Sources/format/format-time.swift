// Created by Leopold Lemmermann on 29.04.23.

import typealias Foundation.TimeInterval
import SwiftUI

@available(iOS 16, *)
extension Format {
  static func time(time: TimeInterval) -> Text {
    guard time.isFinite else { return Text("NO_DATA") }
    
    let formatter = DateComponentsFormatter()
    formatter.maximumUnitCount = 1
    formatter.unitsStyle = .full
    return Text(formatter.string(from: time) ?? "")
  }
}
