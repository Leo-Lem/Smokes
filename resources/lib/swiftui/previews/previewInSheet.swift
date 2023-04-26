// Created by Leopold Lemmermann on 27.04.23.

import SwiftUI

public extension View {
  func previewInSheet() -> some View {
    Binding.Preview(false) { binding in
      Button("[Sheet]") { binding.wrappedValue.toggle() }
        .sheet(isPresented: binding) { self }
        .onAppear { binding.wrappedValue = true }
    }
    .previewDisplayName("Sheet")
  }
}
