// Created by Leopold Lemmermann on 23.02.23.

import SwiftUI

extension View {
  func attachPlot<Plot: View>(@ViewBuilder _ plot: @escaping () -> Plot) -> some View {
    modifier(PlotAttacher(plot: plot()))
  }
}

private struct PlotAttacher<Plot: View>: ViewModifier {
  let plot: Plot

  func body(content: Content) -> some View {
    GeometryReader { geo in
      HStack {
        content
          .overlay(alignment: .topTrailing) {
            Button { showingPlot.toggle() } label: { Label("SHOW_PLOT", systemImage: "chart.bar.xaxis")}
              .imageScale(.large)
              .font(.headline)
          }

        if showingPlot {
          plot
            .frame(minWidth: geo.size.width * 2 / 3)
            .transition(.move(edge: .trailing))
        }
      }

      .onTapGesture { showingPlot.toggle() }
      .animation(.default, value: showingPlot)
    }
  }

  @State private var showingPlot = false
}
// MARK: - (PREVIEWS)

struct AmountWithPlotWidget_Previews: PreviewProvider {
  static var previews: some View {
    AmountWithLabel(10, description: "Today")
      .attachPlot {
        DatedAmountsPlot(data: [
          DateInterval(start: .now, duration: 86400): 140,
          DateInterval(start: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!, duration: 86400): 70,
          DateInterval(start: Calendar.current.date(byAdding: .month, value: -1, to: .now)!, duration: 86400): 110
        ], description: nil)
      }
      .frame(maxHeight: 200)
      .padding()
  }
}
