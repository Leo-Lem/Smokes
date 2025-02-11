// Created by Leopold Lemmermann on 24.04.23.

import Charts
import SwiftUI

public struct AmountsChart: View {
  let amounts: [(label: String, amount: Int)]

  public var body: some View {
    Chart(amounts, id: \.label) { label, amount in
      BarMark(x: .value(String(localized: "date"), label),
              y: .value(String(localized: "smokes"), amount))
    }
    .minimumScaleFactor(0.5)
    .chartYAxisLabel("smokes")
  }

  public init(_ amounts: [(label: String, amount: Int)]) { self.amounts = amounts }
}

#Preview {
  AmountsChart([("2023-12-23", 10), ("2023-12-24", 0), ("2023-12-25", 1)])
    .padding()
}

#Preview("Empty") {
  AmountsChart([("2023-12-23", 0), ("2023-12-24", 0), ("2023-12-25", 0)])
    .padding()
}
