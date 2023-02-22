// Created by Leopold Lemmermann on 23.02.23.

import Charts
import SwiftUI

struct PlotWidget: View {
  let description: String
  var data: [Date: Int]
  
  var body: some View {
    VStack {
      Chart {
        ForEach(Array(data.keys), id: \.self) { key in
          BarMark(x: .value("Date", key), y: .value("Amount", data[key] ?? 0))
        }
      }
      .animation(.default, value: data)
      
      Text(description)
        .font(.subheadline)
        .lineLimit(1)
    }
    .padding()
    .widgetStyle()
  }
}

struct PlotWidget_Previews: PreviewProvider {
  static var previews: some View {
    PlotWidget(
      description: "Some plot",
      data: [
        .now: 140,
        Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!: 70,
        Calendar.current.date(byAdding: .month, value: -1, to: .now)!: 110
      ]
    )
    .padding()
  }
}
