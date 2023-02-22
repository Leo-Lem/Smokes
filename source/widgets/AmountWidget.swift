// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI

struct AmountWidget: View {
  let amount: Double, description: String

  var body: some View {
    VStack {
      Text(((amount*100).rounded() / 100).formatted())
        .font(.largeTitle)

      Text(description)
        .font(.subheadline)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
    .lineLimit(1)
    .widgetStyle()
  }

  init(_ amount: Double, description: String) {
    (self.amount, self.description) = (amount, description)
  }

  init(_ amount: Int, description: String) {
    self.init(Double(amount), description: description)
  }
}

struct AmountWidget_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      AmountWidget(0, description: "default")
      AmountWidget(1000, description: "Large number")
      AmountWidget(10, description: "Long description here, some more space")
      AmountWidget(1.9890000, description: "Decimal")
    }
  }
}
