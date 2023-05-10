// Created by Leopold Lemmermann on 26.04.23.

import SwiftUI

struct InfoView: View {
  var body: some View {
    VStack {
      Text(INFO.APPNAME)
        .font(.largeTitle)
        .bold()
        .padding()
      
      Text("APP_DESCRIPTION")
        .multilineTextAlignment(.center)
    
    Spacer()
      Divider()
      
      Section("LINKS") {
        VStack(alignment: .leading, spacing: 5) {
          Link(destination: INFO.LINKS.WEBPAGE) {
            Label("WEBPAGE \(INFO.LINKS.WEBPAGE)", systemImage: "safari")
          }
          
          Link(destination: INFO.LINKS.SUPPORT) {
            Label("SUPPORT \(INFO.LINKS.SUPPORT)", systemImage: "questionmark.circle")
          }
          
          Link(destination: INFO.LINKS.PRIVACY_POLICY) {
            Label("PRIVACY_POLICY \(INFO.LINKS.PRIVACY_POLICY)", systemImage: "person.badge.key")
          }
        }
        .italic()
      }
      .lineLimit(1)
      
      Divider()
      
      Section("CREDITS") {
        VStack {
          Text("DEVELOPERS \(INFO.CREDITS.DEVELOPERS.joined(separator: ", "))")
          Text("DESIGNERS \(INFO.CREDITS.DESIGNERS.joined(separator: ", "))")
        }
        .font(.caption)
      }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .presentationDetents([.medium])
    .presentationBackground(.ultraThinMaterial, legacy: Color("BackgroundColor"))
    .compactDismissButton()
  }
}

// MARK: - (PREVIEWS)

struct InfoView_Previews: PreviewProvider {
  static var previews: some View {
    InfoView().previewInSheet()
      .environment(\.locale, .init(identifier: "de"))
  }
}
