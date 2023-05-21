// Created by Leopold Lemmermann on 24.04.23.

import Charts
import SwiftUI

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
      .overlay {
        if isEmpty {
          Text("NO_DATA")
            .font(.largeTitle)
            .bold()
            .rotationEffect(.degrees(-10))
        }
      }
    }
  }
  
  private let isEmpty: Bool
  
  init(_ amounts: [(label: String, amount: Int)]?, description: Text? = nil) {
    self.amounts = amounts
    self.description = description
    
    if let amounts {
      isEmpty = !amounts.contains(where: { $0.amount > 0 })
    } else { isEmpty = false }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct AmountsChart_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AmountsChart([("2023-12-23", 10), ("2023-12-24", 0), ("2023-12-25", 1)])

      AmountsChart([("2023-12-23", 0), ("2023-12-24", 0), ("2023-12-25", 0)])
        .previewDisplayName("Empty")
      
      AmountsChart(nil)
        .previewDisplayName("Loading")
    }
    .padding()
  }
}
#endif
