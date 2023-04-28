// Created by Leopold Lemmermann on 27.04.23.

import SwiftUI

public extension View {
  @ViewBuilder func presentationBackground<S1: ShapeStyle, S2: ShapeStyle>(_ style: S1, legacy: S2) -> some View {
    if #available(iOS 16.4, *) {
      presentationBackground(style)
    } else {
      background(legacy)
    }
  }
}
