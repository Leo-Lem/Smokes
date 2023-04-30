// Created by Leopold Lemmermann on 25.03.23.

import SwiftUI

struct Background: View {
  var body: some View {
    ZStack {
      Color("BackgroundColor")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      
      Image(decorative: "no-smoking")
        .resizable()
        .scaledToFit()
    }
    .ignoresSafeArea()
  }
}

// MARK: - (PREVIEWS)

struct Background_Previews: PreviewProvider {
  static var previews: some View {
    Background()
  }
}
