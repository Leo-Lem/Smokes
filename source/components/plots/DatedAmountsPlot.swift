// Created by Leopold Lemmermann on 23.02.23.

import Charts
import SwiftUI

struct DatedAmountsPlot: View {
  let data: [DateInterval: Int], description: LocalizedStringKey?
  
  var body: some View {
    VStack {
      if containsNoData {
        Text("NO_DATA")
          .font(.largeTitle)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        Chart {
          ForEach(Array(data.keys), id: \.self) { key in
            BarMark(
              x: .value("DATE", key.start),
              y: .value("AMOUNT", data[key] ?? 0)
            )
          }
        }
        .animation(.default, value: data)
      }
      
      if let description {
        Text(description)
          .font(.subheadline)
          .lineLimit(1)
      }
    }
    .accessibilityLabel(Text(description ?? "NO_DESCRIPTION"))
    .padding()
  }
  
  private var containsNoData: Bool {
    data.allSatisfy { $0.value == 0 }
  }
}

// MARK: - (PREVIEWS)

struct PlotWidget_Previews: PreviewProvider {
  static var previews: some View {
    DatedAmountsPlot(
      data: [
        DateInterval(start: .now, duration: 86400): 140,
        DateInterval(start: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!, duration: 86400): 70,
        DateInterval(start: Calendar.current.date(byAdding: .month, value: -1, to: .now)!, duration: 86400): 110
      ],
      description: "Some plot"
    )
    .padding()
  }
}
