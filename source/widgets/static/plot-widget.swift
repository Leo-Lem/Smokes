// Created by Leopold Lemmermann on 23.02.23.

import Charts
import SwiftUI

struct PlotWidget: View {
  let data: [DateInterval: Int], description: String?
  
  var body: some View {
    VStack {
      Chart {
        ForEach(Array(data.keys), id: \.self) { key in
          BarMark(
            x: .value("Date", key.start),
            y: .value("Amount", data[key] ?? 0)
          )
        }
      }
      .animation(.default, value: data)
      
      if let description {
        Text(description)
          .font(.subheadline)
          .lineLimit(1)
      }
    }
    .padding()
    .widgetStyle()
  }
}

// MARK: - (PREVIEWS)

struct PlotWidget_Previews: PreviewProvider {
  static var previews: some View {
    PlotWidget(
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
