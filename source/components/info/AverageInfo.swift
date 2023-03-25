// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI

struct AverageInfo: View {
  let average: Double?, description: LocalizedStringKey

  var body: some View {
    BaseInfo(formatted, description: Text(description))
  }
  
  private var formatted: Text? {
    average
      .flatMap { ($0 * 100).rounded() / 100 }
      .flatMap {
      Text("\($0) SMOKES_PLURAL_VALUE")
      + Text(" ")
      + Text("\($0) SMOKES_PLURAL_LABEL").font(.headline)
    }
  }

  init(_ average: Double?, description: LocalizedStringKey) {
    (self.average, self.description) = (average, description)
  }
}

// MARK: - (PREVIEWS)

struct AverageInfo_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      AverageInfo(1.9890000, description: "default")
    }
  }
}
