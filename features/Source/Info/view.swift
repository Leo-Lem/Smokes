// Created by Leopold Lemmermann on 26.04.23.

import Bundle
import ComposableArchitecture
import Extensions
import SwiftUI

public struct InfoView: View {
  public let store: StoreOf<Info>

  public var body: some View {
    VStack {
      Text(string("CFBundleDisplayName"))
        .font(.largeTitle)
        .lineLimit(1)
        .bold()
        .padding()

      Text("We're here to help you get an overview of your smoking habit, and help you to overcome it!")
        .multilineTextAlignment(.center)

    Spacer()
      Divider()

      Section("Links") {
        List {
          Group {
            Button("Webpage", systemImage: "safari") { store.send(.openMarketing) }
              .labelStyle(.external(color: .green, transfer: true))

            Button("Support", systemImage: "questionmark.circle") { store.send(.openSupport) }
              .labelStyle(.external(color: .red, transfer: true))

            Button("Privacy Policy", systemImage: "person.badge.key") { store.send(.openPrivacy) }
              .labelStyle(.external(color: .gray, transfer: true))
          }
          .listRowBackground(Color.clear)
        }
        .bold()
        .listStyle(.plain)
        .buttonStyle(.borderless)
        .scrollDisabled(true)
      }

      Divider()

      Section("Credits") {
        VStack {
          Text("Developed by \(string("SmokesCreator"))")
          Text("Designed by \(string("SmokesCreator"))")
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
