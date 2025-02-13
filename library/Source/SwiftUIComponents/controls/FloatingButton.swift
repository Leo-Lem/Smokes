// Created by Leopold Lemmermann on 03.02.25.

import SwiftUI

public struct FloatingButton: View {
  let label: String,
      systemImage: String,
      action: () -> Void

  public var body: some View {
    Button(action: action) { Label(label, systemImage: systemImage) }
      .labelStyle(.iconOnly)
      .buttonStyle(.borderedProminent)
      .shadow(color: .primary, radius: 5)
  }

  public init(_ label: String, systemImage: String, action: @escaping () -> Void) {
    self.label = label
    self.systemImage = systemImage
    self.action = action
  }
}
