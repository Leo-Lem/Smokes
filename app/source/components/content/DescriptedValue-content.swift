// Created by Leopold Lemmermann on 01.04.23.

import SwiftUI

struct DescriptedValueContent: View {
  let value: Text?, description: Text
  
  var body: some View {
    VStack {
      Spacer()
      
      if let value {
        value
          .font(.largeTitle)
          .minimumScaleFactor(0.7)
          .id(Int.random(in: 0 ..< 100))
          .transition(.push(from: .top))
      } else {
        ProgressView()
      }
      
      Spacer()
      
      description
        .font(.subheadline)
        .italic()
        .minimumScaleFactor(0.8)
    }
    .lineLimit(1)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .accessibilityElement()
    .accessibilityLabel(description)
    .accessibilityValue(value ?? Text("LOADING"))
    .accessibilityAddTraits(.isStaticText)
  }
  
  init(_ value: Text?, description: LocalizedStringKey) {
    (self.value, self.description) = (value, Text(description))
  }
  
  init(_ value: Text?, description: Text) {
    (self.value, self.description) = (value, description)
  }
}

// MARK: - (PREVIEWS)

struct DescriptedValueContent_Previews: PreviewProvider {
  static var previews: some View {
    DescriptedValueContent(Text("Hello"), description: "Some description")
  }
}
