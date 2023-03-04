// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI

struct IncrementWidget: View {
  let decrementDisabled: Bool
  let add: () -> Void, remove: () -> Void

  var body: some View {
    GeometryReader { geo in
      let size = min(geo.size.width, geo.size.height)
      
      ZStack(alignment: .topLeading) {
        Button(action: add) {
          Image(systemName: "plus")
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(.largeTitle)
        }
        
        Button(action: remove) {
          Image(systemName: "minus")
            .frame(maxWidth: size / 4, maxHeight: size / 4)
            .background(.ultraThickMaterial)
            .cornerRadius(5)
            .shadow(radius: 3)
            .padding(5)
            .font(.headline)
        }
        .disabled(decrementDisabled)
      }
    }
    .imageScale(.large)
    .minimumScaleFactor(0.2)
    .widgetStyle()
  }
}

struct IncrementWidget_Previews: PreviewProvider {
  static var previews: some View {
    IncrementWidget(decrementDisabled: false) {} remove: {}
      .frame(maxWidth: 100, maxHeight: 100)
      .previewDisplayName("Small")
    
    IncrementWidget(decrementDisabled: false) {} remove: {}
      .frame(maxWidth: 200, maxHeight: 200)
      .previewDisplayName("Medium")
    
    IncrementWidget(decrementDisabled: false) {} remove: {}
      .previewDisplayName("Large")
    
    IncrementWidget(decrementDisabled: false) {} remove: {}
      .frame(maxHeight: 100)
      .previewDisplayName("Wide")
  }
}