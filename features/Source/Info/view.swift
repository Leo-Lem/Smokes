// Created by Leopold Lemmermann on 26.04.23.

import typealias ComposableArchitecture.StoreOf
import Extensions
import SwiftUI

public struct InfoView: View {
  public let store: StoreOf<Info>

  public var body: some View {
    VStack {
      Text(Bundle.main[string: "CFBundleDisplayName"])
        .font(.largeTitle)
        .lineLimit(1)
        .bold()
        .padding()

      Text("We're here to help you get a grip on your smoking habit, and help you to overcome it!", bundle: .module)
        .multilineTextAlignment(.center)

    Spacer()
      Divider()

      Section(String(localized: "Links", bundle: .module)) {
        List {
          Group {
            Button(String(localized: "Webpage", bundle: .module), systemImage: "safari") {
              store.send(.openMarketing)
            }
            .labelStyle(.external(color: .green, transfer: true))

            Button(String(localized: "Support", bundle: .module), systemImage: "questionmark.circle") {
              store.send(.openSupport)
            }
            .labelStyle(.external(color: .red, transfer: true))

            Button(String(localized: "Privacy Policy", bundle: .module), systemImage: "person.badge.key") {
              store.send(.openPrivacy)
            }
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

      Section(String(localized: "Credits", bundle: .module)) {
        VStack {
          Text("Developed by \(Bundle.main[string: "SmokesCreator"])", bundle: .module)
          Text("Designed by \(Bundle.main[string: "SmokesCreator"])", bundle: .module)
        }
        .font(.caption)
      }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .presentationDetents([.medium])
    .presentationBackground(.ultraThinMaterial)
  }

  public init(store: StoreOf<Info>) { self.store = store }
}

#Preview {
  InfoView(store: StoreOf<Info>(initialState: Info.State(), reducer: Info.init))
    .previewInSheet()
}
