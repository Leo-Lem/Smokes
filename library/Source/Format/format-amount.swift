// Created by Leopold Lemmermann on 29.04.23.

import SwiftUI

extension Format {
  static func amount(_ amount: Int) -> Text {
    Text("\(amount) smokes").font(.headline)
  }
}
