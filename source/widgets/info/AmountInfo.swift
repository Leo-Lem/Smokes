// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI

struct AmountInfo: View {
  let amount: Int?, description: LocalizedStringKey

  var body: some View {
    BaseInfo(formatted, description: Text(description))
  }
  
  private var formatted: Text? {
    amount.flatMap {
      Text("\($0) SMOKES_PLURAL_VALUE")
      + Text(" ")
      + Text("\($0) SMOKES_PLURAL_LABEL").font(.headline)
    }
  }
  
  init(_ amount: Int?, description: LocalizedStringKey) {
    (self.amount, self.description) = (amount, description)
  }
}

// MARK: - (PREVIEWS)

struct AmountInfo_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      AmountInfo(0, description: "default")
      AmountInfo(1, description: "Large number")
      AmountInfo(10, description: "Long description here, some more space")
    }
  }
}
