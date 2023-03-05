// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI

struct AmountWidget: View {
  let amount: Double?, description: String

  var body: some View {
    VStack {
      Spacer()
      
      if let formattedAmount {
        Text(formattedAmount)
          .font(.largeTitle)
          .minimumScaleFactor(0.5)
          .id(formattedAmount)
          .transition(.push(from: .top))
      } else {
        ProgressView()
          .scaleEffect(1.5)
      }

      Spacer()

      Text(description)
        .font(.subheadline)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
    .lineLimit(1)
    .widgetStyle()
  }

  private var formattedAmount: String? {
    amount.flatMap { (($0 * 100).rounded() / 100).formatted() }
  }

  init(_ amount: Double?, description: String) {
    (self.amount, self.description) = (amount, description)
  }

  init(_ amount: Int?, description: String) {
    self.init(amount.flatMap(Double.init), description: description)
  }
}

// MARK: - (PREVIEWS)

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
