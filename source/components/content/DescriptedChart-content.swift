// Created by Leopold Lemmermann on 01.04.23.

import Charts
import SwiftUI

struct DescriptedChartContent<Data: RandomAccessCollection, Chart: View>: View {
  let data: Data?
  let description: Text?
  let chart: (Data) -> Chart
  
  var body: some View {
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
    .accessibilityLabel(description ?? Text("NO_DESCRIPTION"))
  }
}

// MARK: - (PREVIEWS)

struct DescriptedChartContent_Previews: PreviewProvider {
  static var previews: some View {
    
    DescriptedChartContent(data: [Int](), description: Text("Some description")) { _ in
      Chart {
        BarMark(x: .value("AMOUNT", 1))
      }
      .chartYAxisLabel(LocalizedStringKey("SMOKES"))
    }
    .previewDisplayName("empty")
  }
}
