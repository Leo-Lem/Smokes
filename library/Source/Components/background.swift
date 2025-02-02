// Created by Leopold Lemmermann on 25.03.23.

import SwiftUI

public struct Background: View {
  public var body: some View {
    ZStack {
      Color("BackgroundColor")
        .frame(maxWidth: .infinity, maxHeight: .infinity)

      Image(decorative: "no-smoking")
        .resizable()
        .scaledToFit()
    }
    .ignoresSafeArea()
  }

  public init() {}
}

#Preview {
  Background()
}
