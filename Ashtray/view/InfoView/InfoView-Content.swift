//  Created by Leopold Lemmermann on 20.01.22.

import MyCustomUI
import SwiftUI

extension InfoView {
  struct Content: View {
    var body: some View {
      VStack {
        Text("TITLE_INFO").font(_defaultFont, size: 30)

        Section {
          Text("INFO_MESSAGE")
            .font(size: 15, padd: false)
            .multilineTextAlignment(.center)
            .rowItem()
        }

        Section("INFO_CREDITS_TITLE") {
          Text("INFO_CREDITS_MESSAGE")
            .font(size: 15)
            .rowItem()
        }

        Spacer()
      }
    }
  }
}

// MARK: - Previews

struct InfoViewContent_Previews: PreviewProvider {
  static var previews: some View {
    InfoView.Content()
  }
}
