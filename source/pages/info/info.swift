// Created by Leopold Lemmermann on 26.04.23.

import SwiftUI

struct InfoView: View {
  var body: some View {
    addBackground {
      Text("Info coming soon")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .presentationDetents([.medium])
    }
  }
}

extension InfoView {
  @ViewBuilder private func addBackground<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    if #available(iOS 16.4, *) {
      content().presentationBackground(.ultraThinMaterial)
    } else {
      content().background(Color("BackgroundColor"))
    }
  }
}

// MARK: - (PREVIEWS)

struct InfoView_Previews: PreviewProvider {
  static var previews: some View {
    Text("")
      .sheet(isPresented: .constant(true), content: InfoView.init)
  }
}
