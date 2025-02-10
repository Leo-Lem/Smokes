// Created by Leopold Lemmermann on 01.04.23.

import Charts
import Extensions
import SwiftUI

public struct DescriptedChartContent<Data: Collection, Chart: View>: View {
  let data: Data?
  let description: Text?
  let chart: (Data) -> Chart

  public var body: some View {
    VStack {
      Spacer()

      if let data {
        chart(data)
          .replaceWhenEmpty(data)
      } else {
        ProgressView()
      }

      Spacer()

      description
        .font(.subheadline)
        .italic()
        .minimumScaleFactor(0.8)
        .lineLimit(1)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .accessibilityElement()
    .accessibilityLabel(description ?? Text("No description", comment: "Placeholder when there is no description."))
  }
}

#Preview {
  DescriptedChartContent(data: [Int](), description: Text("Some description")) { _ in
    Chart {
      BarMark(x: .value("amount", 1))
    }
    .chartYAxisLabel("smokes")
  }
}
