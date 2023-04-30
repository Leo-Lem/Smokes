// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI

struct Widget<Content: View>: View {
  @ViewBuilder let content: () -> Content
  
  var body: some View {
    VStack(content: content)
      .padding(10)
      .background(.thinMaterial)
      .cornerRadius(10)
      .shadow(color: .primary, radius: 2)
      .padding(2)
  }
}

// MARK: - (PREVIEWS)

struct Widget_Previews: PreviewProvider {
  static var previews: some View {
    Widget {
      Text("Hello, world!")
    }
  }
}
