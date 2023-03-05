// Created by Leopold Lemmermann on 23.02.23.

import SwiftUI

extension View {
  func attachPorter() -> some View { modifier(PorterAttacher()) }
}

private struct PorterAttacher: ViewModifier {
  func body(content: Content) -> some View {
    content
      .overlay(alignment: .bottomLeading) {
        Button(systemImage: "folder") { showingPorter = true }
          .padding(5)
      }
      .sheet(isPresented: $showingPorter, content: Porter.init)
  }
  
  @State private var showingPorter = false
}
