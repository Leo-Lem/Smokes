// Created by Leopold Lemmermann on 24.04.23.

import Charts
import SwiftUI
import enum Generated.L10n

public struct AmountsChart: View {
  let amounts: [(label: String, amount: Int)]?
  let description: Text?

  public var body: some View {
    DescriptedChartContent(data: amounts, description: description) { amounts in
      Chart(amounts, id: \.label) { label, amount in
        BarMark(x: .value(L10n.Plot.date, label), y: .value(L10n.Plot.smokes, amount))
      }
      .minimumScaleFactor(0.5)
      .chartYAxisLabel(LocalizedStringKey(L10n.Plot.smokes))
      .overlay {
        if isEmpty {
          Text(L10n.Placeholder.data)
            .font(.largeTitle)
            .bold()
            .rotationEffect(.degrees(-10))
        }
      }
    }
  }

  private let isEmpty: Bool

  public init(_ amounts: [(label: String, amount: Int)]?, description: Text? = nil) {
    self.amounts = amounts
    self.description = description

    if let amounts {
      isEmpty = !amounts.contains(where: { $0.amount > 0 })
    } else { isEmpty = false }
  }
}

#Preview {
  AmountsChart([("2023-12-23", 10), ("2023-12-24", 0), ("2023-12-25", 1)])
    .padding()
}

#Preview("Empty") {
  AmountsChart([("2023-12-23", 0), ("2023-12-24", 0), ("2023-12-25", 0)])
    .padding()
}

#Preview("Loading") {
  AmountsChart(nil)
    .padding()
}
