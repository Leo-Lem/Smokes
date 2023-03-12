// Created by Leopold Lemmermann on 23.02.23.

import SwiftUI

extension View {
  func attachPorter() -> some View { modifier(PorterAttacher()) }
}

private struct PorterAttacher: ViewModifier {
  func body(content: Content) -> some View {
    content
      .overlay(alignment: .topLeading) {
        Button(systemImage: "folder") { showingPorter = true }
      }
      .sheet(isPresented: $showingPorter) { Porter().padding() }
  }
  
  @State private var showingPorter = false
}
