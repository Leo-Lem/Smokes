// Created by Leopold Lemmermann on 04.03.23.

import Foundation
import SmokesReducers

extension Persistor {
  static let previewValue = Self(
    writeDates: { _ in },
    readDates: { (0..<1000).map { _ in Date(timeIntervalSinceNow: -Double.random(in: 0..<9_999_999)) } }
  )
}
