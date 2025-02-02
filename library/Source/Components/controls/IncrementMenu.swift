// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI

public struct IncrementMenu: View {
  public let decrementDisabled: Bool
  public let add: () -> Void, remove: () -> Void

  public var body: some View {
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

  public init(
    decrementDisabled: Bool = false,
    add: @escaping () -> Void,
    remove: @escaping () -> Void
  ) {
    self.decrementDisabled = decrementDisabled
    self.add = add
    self.remove = remove
  }
}

#Preview("Small") {
  IncrementMenu(decrementDisabled: false) {} remove: {}
    .frame(maxWidth: 100, maxHeight: 100)
}

#Preview("Medium") {
  IncrementMenu(decrementDisabled: false) {} remove: {}
    .frame(maxWidth: 200, maxHeight: 200)
}

#Preview("Large") {
  IncrementMenu(decrementDisabled: false) {} remove: {}
}

#Preview("Wide") {
  IncrementMenu(decrementDisabled: false) {} remove: {}
    .frame(maxHeight: 100)
}
