// Created by Leopold Lemmermann on 29.04.23.

import SwiftUI

extension Format {
  static func amount(_ amount: Int) -> Text {
    Text("\(amount) SMOKES_PLURAL_VALUE")
      + Text(" ")
      + Text("\(amount) SMOKES_PLURAL_LABEL").font(.headline)
  }
}
