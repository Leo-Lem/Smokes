// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI

extension View {
  func widgetStyle() -> some View {
    self
      .background(.thinMaterial)
      .cornerRadius(10)
      .shadow(color: .primary, radius: 2)
      .padding(2)
  }
}
