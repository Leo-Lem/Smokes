// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI

public struct Widget<Content: View>: View {
  @ViewBuilder let content: () -> Content

  public var body: some View {
    VStack(content: content)
      .padding()
      .background(.thinMaterial)
      .cornerRadius(10)
      .shadow(color: .primary, radius: 2)
      .padding(2)
  }

  public init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
}

#Preview {
  Widget {
    Text("Hello, world!")
  }
}
