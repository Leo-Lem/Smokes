// Created by Leopold Lemmermann on 26.04.23.

import Bundle
import ComposableArchitecture
import Extensions
import SwiftUI

public struct InfoView: View {
  public let store: StoreOf<Info>

  public var body: some View {
    VStack {
      Text(string("BUNDLE_NAME"))
        .font(.largeTitle)
        .bold()
        .padding()

      Text("APP_DESCRIPTION")
        .multilineTextAlignment(.center)

    Spacer()
      Divider()

      Section("LINKS") {
        List {
          Button { store.send(.openMarketing) } label: {
            Label("WEBPAGE \(string("MARKETING_WEBPAGE"))", systemImage: "safari")
          }
          .listRowBackground(Color.clear)

          Button { store.send(.openSupport) } label: {
            Label("SUPPORT \(string("SUPPORT_WEBPAGE"))", systemImage: "questionmark.circle")
          }
          .listRowBackground(Color.clear)

          Button { store.send(.openPrivacy) } label: {
            Label("PRIVACY_POLICY \(string("PRIVACY_POLICY"))", systemImage: "person.badge.key")
          }
          .listRowBackground(Color.clear)
        }
        .scrollDisabled(true)
        .listStyle(.plain)
        .italic()
      }
      .lineLimit(1)

      Divider()

      Section("CREDITS") {
        VStack {
          Text("DEVELOPERS \(string("CREATOR"))")
          Text("DESIGNERS \(string("CREATOR"))")
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
