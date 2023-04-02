// Created by Leopold Lemmermann on 12.03.23.

import Charts
import ComposableArchitecture
import SwiftUI

struct StatsView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store) {
      ViewState($0, interval: selection)
    } send: {
      ViewAction.send($0)
    } content: { vs in
      Grid {
        if vSize == .regular {
          configurableAverageWidget { vs.configurableAverages[$0]?.optional }

          amountsPlotWidget(vs.configurableEntries[option]?.optional, option: option, bounds: selection)

          GridRow {
            averageTimeBetweenWidget(vs.averageTimeBetween)
            trendWidget(vs.configurableTrends[option]?.optional)
          }
        } else {
          configurableAverageWidget { vs.configurableAverages[$0]?.optional }
          averageTimeBetweenWidget(vs.averageTimeBetween)
          trendWidget(vs.configurableTrends[option]?.optional)
        }

        intervalPicker($selection, bounds: vs.bounds)
      }
      .animation(.default, value: vs.state)
      .onAppear {
        vs.send(.loadAverage(selection))
        Option.allCases.forEach { vs.send(.loadTrend($0, interval: selection)) }
      }
      .onChange(of: selection) { _ in
        vs.send(.loadAverage(selection))
        Option.allCases.forEach { vs.send(.loadTrend($0, interval: selection)) }
      }
    }
  }

  @State private var selection = Interval.alltime  // TODO: add @AppStorage("history_selection")
  @AppStorage("history_averageOption") private var option = Option.perday

  @Environment(\.verticalSizeClass) private var vSize
  @Dependency(\.formatter) private var formatter
}

extension StatsView {
  private func trendWidget(_ trend: Double?) -> some View {
    Widget {
      DescriptedValueContent(
        formatter.format(trend: trend), description: Text(option.description) + Text(" ") + Text("(TREND)")
      )
    }
  }

  private func configurableAverageWidget(_ average: @escaping (Option) -> Double?) -> some View {
    ConfigurableWidget(selection: $option) { option in
      DescriptedValueContent(formatter.format(average: average(option)), description: option.description)
    }
  }

  private func intervalPicker(_ selection: Binding<Interval>, bounds: Interval) -> some View {
    Widget {
      IntervalPicker(selection: selection, bounds: bounds)
        .labelStyle(.iconOnly)
        .buttonStyle(.borderedProminent)
    }
  }

  private func averageTimeBetweenWidget(_ time: TimeInterval?) -> some View {
    Widget {
      DescriptedValueContent(formatter.format(time: time), description: "AVERAGE_TIME_BETWEEN")
    }
  }

  private func amountsPlotWidget(_ entries: [Date]?, option: Option, bounds: Interval) -> some View {
    Widget {
      DescriptedChartContent(data: entries, description: nil) { _ in
        Text("Chart is coming soon")
//        Chart(option.groups(from: data), id: \.self) { group in
//          BarMark(
//            x: .value("DATE", group),
//            y: .value("AMOUNT", option.amount(from: data, for: group))
//          )
//        }
//        .chartXScale(domain: option.domain(bounds))
//        .chartXAxisLabel(option.xLabel)
//        .chartYAxisLabel(LocalizedStringKey("SMOKES"))
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct StatsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      StatsView()
        .environment(\.verticalSizeClass, .regular)
        .previewDisplayName("Regular")

      StatsView()
        .environment(\.verticalSizeClass, .compact)
        .previewDisplayName("Compact")
    }
    .padding()
    .environmentObject(Store(initialState: .init(), reducer: MainReducer()))
  }
}
#endif
