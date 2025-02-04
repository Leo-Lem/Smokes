// Created by Leopold Lemmermann on 26.04.23.

import Bundle
import Extensions
import SwiftUI

public struct InfoView: View {
  public var body: some View {
    VStack {
      Text(bundle.string("BUNDLE_NAME"))
        .font(.largeTitle)
        .bold()
        .padding()

      Text("APP_DESCRIPTION")
        .multilineTextAlignment(.center)

    Spacer()
      Divider()

      Section("LINKS") {
        List {
          Link(destination: URL(string: bundle.string("MARKETING_WEBPAGE"))!) {
            Label("WEBPAGE \(bundle.string("MARKETING_WEBPAGE"))", systemImage: "safari")
          }
          .listRowBackground(Color.clear)

          Link(destination: URL(string: bundle.string("SUPPORT_WEBPAGE"))!) {
            Label("SUPPORT \(bundle.string("SUPPORT_WEBPAGE"))", systemImage: "questionmark.circle")
          }
          .listRowBackground(Color.clear)

          Link(destination: URL(string: bundle.string("PRIVACY_POLICY"))!) {
            Label("PRIVACY_POLICY \(bundle.string("PRIVACY_POLICY"))", systemImage: "person.badge.key")
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
          Text("DEVELOPERS \(bundle.string("CREATOR"))")
          Text("DESIGNERS \(bundle.string("CREATOR"))")
        }
        .font(.caption)
      }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .presentationDetents([.medium])
    .presentationBackground(.ultraThinMaterial, legacy: Color("BackgroundColor"))
  }

  @Dependency(\.bundle) var bundle

  public init() {}
}

#Preview {
  InfoView()
    .previewInSheet()
}
