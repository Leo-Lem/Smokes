// Created by Leopold Lemmermann on 24.04.23.

import Charts
import SwiftUI

// TODO: move the calculations into reducer

struct AmountsChart: View {
  let amounts: [(label: String, amount: Int)]?
  let description: Text?

  var body: some View {
    DescriptedChartContent(data: amounts, description: description) { amounts in
      Chart(amounts, id: \.label) { label, amount in
        BarMark(x: .value("DATE", label), y: .value("AMOUNT", amount))
      }
      .minimumScaleFactor(0.5)
      .chartYAxisLabel(LocalizedStringKey("SMOKES"))
    }
  }
  
  init(_ amounts: [(label: String, amount: Int)]?, description: Text? = nil) {
    self.amounts = amounts
    self.description = description
  }
}

// MARK: - (PREVIEWS)

struct AmountsChart_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AmountsChart([("2023-12-23", 10), ("2023-12-24", 0), ("2023-12-25", 1)], description: nil)

      AmountsChart(nil)
        .previewDisplayName("Loading")
    }
    .padding()
  }
}
