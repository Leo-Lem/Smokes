// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI

struct BaseInfo: View {
  let value: Text?, description: Text

  var body: some View {
    VStack {
      Spacer()
      
      if let value {
        value
          .font(.largeTitle)
          .minimumScaleFactor(0.7)
          .id(Int.random(in: 0..<100))
          .transition(.push(from: .top))
      } else {
        ProgressView()
          .scaleEffect(1.5)
      }

      Spacer()

      description
        .font(.subheadline)
        .italic()
        .minimumScaleFactor(0.8)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .lineLimit(1)
    .accessibilityElement()
    .accessibilityLabel(description)
    .accessibilityValue(value ?? Text("LOADING"))
    .accessibilityAddTraits(.isStaticText)
  }

  init(_ value: Text?, description: Text) {
    (self.value, self.description) = (value, description)
  }
}

// MARK: - (PREVIEWS)

struct BaseInfo_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      BaseInfo(Text("10"), description: Text("basic"))
      BaseInfo(Text("10"), description: Text("Long description here, some more space"))
      BaseInfo(Text("1.989"), description: Text("Decimal"))
    }
  }
}
