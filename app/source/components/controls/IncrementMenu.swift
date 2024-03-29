// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI

struct IncrementMenu: View {
  let decrementDisabled: Bool
  let add: () -> Void, remove: () -> Void

  var body: some View {
    GeometryReader { geo in
      let size = min(geo.size.width, geo.size.height)
      
      ZStack(alignment: .topLeading) {
        Button(action: add) {
          Label("ADD", systemImage: "plus")
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(.largeTitle)
            .accessibilityIdentifier("add-button")
        }
        
        Button(action: remove) {
          Label("REMOVE", systemImage: "minus")
            .frame(maxWidth: size / 4, maxHeight: size / 4)
            .background(.ultraThickMaterial)
            .cornerRadius(5)
            .shadow(radius: 3)
            .padding(5)
            .font(.headline)
            .accessibilityIdentifier("remove-button")
        }
        .disabled(decrementDisabled)
      }
      .labelStyle(.iconOnly)
    }
    .imageScale(.large)
    .minimumScaleFactor(0.2)
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct IncrementWidget_Previews: PreviewProvider {
  static var previews: some View {
    IncrementMenu(decrementDisabled: false) {} remove: {}
      .frame(maxWidth: 100, maxHeight: 100)
      .previewDisplayName("Small")
    
    IncrementMenu(decrementDisabled: false) {} remove: {}
      .frame(maxWidth: 200, maxHeight: 200)
      .previewDisplayName("Medium")
    
    IncrementMenu(decrementDisabled: false) {} remove: {}
      .previewDisplayName("Large")
    
    IncrementMenu(decrementDisabled: false) {} remove: {}
      .frame(maxHeight: 100)
      .previewDisplayName("Wide")
  }
}
#endif
