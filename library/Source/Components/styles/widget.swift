// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI

public extension View {
  func widgetStyle() -> some View {
    self
      .padding()
      .background(
        .thinMaterial.shadow(.drop(color: .primary, radius: 2)),
        in: .rect(cornerRadius: 10)
      )
  }

  func widgetStyle<Option>(_ selection: Binding<Option>,
                           enabled: Option.AllCases = Option.allCases,
                           alignment: Alignment = .topLeading) -> some View
  where Option: Hashable & CaseIterable & RawRepresentable<String>, Option.AllCases: RandomAccessCollection {
    self
      .widgetStyle()
      .overlay(alignment: alignment) {
        Menu("configure", systemImage: "arrowtriangle.down.circle.fill") {
          ForEach(enabled, id: \.self) { option in
            Button(option.rawValue) {
              selection.wrappedValue = option
            }
          }
        }
        .imageScale(.large)
        .labelStyle(.iconOnly)
        .padding(5)
      }
  }
}

#Preview {
  Text("Hello, world!")
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .widgetStyle()
}

private enum AmountSelection: String, CaseIterable { case week, month, year }
#Preview("configurable") {
  Text("Hello, world!")
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .widgetStyle(.constant(AmountSelection.week))
}
