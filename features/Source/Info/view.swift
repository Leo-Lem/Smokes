// Created by Leopold Lemmermann on 26.04.23.

import Bundle
import ComposableArchitecture
import Extensions
import SwiftUI
import enum Generated.L10n

public struct InfoView: View {
  public let store: StoreOf<Info>

  public var body: some View {
    VStack {
      Text(string("BUNDLE_NAME"))
        .font(.largeTitle)
        .bold()
        .padding()

      Text(L10n.Info.description)
        .multilineTextAlignment(.center)

    Spacer()
      Divider()

      Section(L10n.Info.links) {
        List {
          Button { store.send(.openMarketing) } label: {
            Label(L10n.Info.Links.webpage(string("MARKETING_WEBPAGE")), systemImage: "safari")
          }
          .listRowBackground(Color.clear)

          Button { store.send(.openSupport) } label: {
            Label(L10n.Info.Links.support(string("SUPPORT_WEBPAGE")), systemImage: "questionmark.circle")
          }
          .listRowBackground(Color.clear)

          Button { store.send(.openPrivacy) } label: {
            Label(L10n.Info.Links.privacy(string("PRIVACY_POLICY")), systemImage: "person.badge.key")
          }
          .listRowBackground(Color.clear)
        }
        .scrollDisabled(true)
        .listStyle(.plain)
        .italic()
      }
      .lineLimit(1)

      Divider()

      Section(L10n.Info.credits) {
        VStack {
          Text(L10n.Info.developers(string("CREATOR")))
          Text(L10n.Info.designers(string("CREATOR")))
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
