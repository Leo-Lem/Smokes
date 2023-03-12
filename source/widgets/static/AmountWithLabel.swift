// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI

struct AmountWithLabel: View {
  let amount: Double?, description: LocalizedStringKey

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
        .minimumScaleFactor(0.5)
        .font(.subheadline)
        .italic()
    }
    .frame(maxWidth: .infinity)
    .padding()
    .lineLimit(1)
  }

  private var formattedAmount: String? {
    amount.flatMap { (($0 * 100).rounded() / 100).formatted() }
  }

  init(_ amount: Double?, description: LocalizedStringKey) {
    (self.amount, self.description) = (amount, description)
  }

  init(_ amount: Int?, description: LocalizedStringKey) {
    self.init(amount.flatMap(Double.init), description: description)
  }
}

// MARK: - (PREVIEWS)

struct AmountWithLabel_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      AmountWithLabel(0, description: "default")
      AmountWithLabel(1000, description: "Large number")
      AmountWithLabel(10, description: "Long description here, some more space")
      AmountWithLabel(1.9890000, description: "Decimal")
    }
  }
}
