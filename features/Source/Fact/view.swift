// Created by Leopold Lemmermann on 26.03.23.

import ComposableArchitecture
import Extensions
import SwiftUI

public struct FactView: View {
  let store: StoreOf<Fact>

  public var body: some View {
    VStack {
      VStack {
        Text(store.fact)
          .font(.headline)
          .multilineTextAlignment(.center)
          .minimumScaleFactor(0.7)

        Color.accentColor
          .frame(maxWidth: 100, maxHeight: 2)
          .cornerRadius(2)

        Text(.localizable(.title))
          .font(.subheadline)
      }
      .frame(maxWidth: .infinity)
      .padding(5)
      .background(.ultraThinMaterial)
      .cornerRadius(5)

      Spacer()

      HStack {
        ProgressView(value: store.progress)
          .padding(5)
          .background(.ultraThinMaterial)
          .cornerRadius(5)

        Button(.localizable(.skip), systemImage: "chevron.forward.to.line") {
          store.send(.dismiss, animation: .default)
        }
        .buttonStyle(.borderedProminent)
        .labelStyle(.iconOnly)
      }
    }
    .onAppear { store.send(.appear, animation: .default) }
  }

  public init(store: StoreOf<Fact>) { self.store = store }
}

#Preview {
  FactView(store: Store(initialState: Fact.State(), reducer: Fact.init))
}
