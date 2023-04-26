// Created by Leopold Lemmermann on 01.04.23.

import SwiftUI

extension View {
  func replaceWhenEmpty<C: Collection>(_ collection: C) -> some View {
    replace(when: collection.isEmpty) { Text("NO_DATA").font(.largeTitle) }
  }

  func replaceWhileLoading(when isLoading: Bool) -> some View {
    replace(when: isLoading) {
      ProgressView()
        .accessibilityValue("LOADING")
    }
  }

  @ViewBuilder
  func replace<Replacement: View>(
    when condition: Bool,
    @ViewBuilder with replacement: () -> Replacement
  ) -> some View {
    if condition {
      replacement()
    } else {
      self
    }
  }
}
