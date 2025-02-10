// Created by Leopold Lemmermann on 26.04.23.

import Bundle
import ComposableArchitecture
import Extensions
import SwiftUI

public struct InfoView: View {
  public let store: StoreOf<Info>

  public var body: some View {
    VStack {
      Text(string("CFBundleName"))
        .font(.largeTitle)
        .bold()
        .padding()

      Text("We're here to help you get an overview of your smoking habit, and help you to overcome it!")
        .multilineTextAlignment(.center)

    Spacer()
      Divider()

      Section("Links") {
        List {
          // TODO: add link button from launchlab
          Button { store.send(.openMarketing) } label: {
            Label("Webpage", systemImage: "safari")
          }
          .listRowBackground(Color.clear)

          Button { store.send(.openSupport) } label: {
            Label("Support", systemImage: "questionmark.circle")
          }
          .listRowBackground(Color.clear)

          Button { store.send(.openPrivacy) } label: {
            Label("Privacy Policy", systemImage: "person.badge.key")
          }
          .listRowBackground(Color.clear)
        }
        .scrollDisabled(true)
        .listStyle(.plain)
        .italic()
      }
      .lineLimit(1)

      Divider()

      Section("Credits") {
        VStack {
          Text("Developed by \(string("CREATOR"))")
          Text("Designed by \(string("CREATOR"))")
        }
        .font(.caption)
      }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .presentationDetents([.medium])
    .presentationBackground(.ultraThinMaterial, legacy: Color("BackgroundColor"))
  }

  @Dependency(\.bundle.string) var string

  public init(store: StoreOf<Info>) { self.store = store }
}

#Preview {
  InfoView(store: Store(initialState: Info.State(), reducer: Info.init))
    .previewInSheet()
}
