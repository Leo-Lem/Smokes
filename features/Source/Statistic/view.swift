// Created by Leopold Lemmermann on 12.03.23.

import Charts
import ComposableArchitecture
import Extensions
import SwiftUI

struct StatisticView: View {
  @EnvironmentObject private var store: StoreOf<App>

  var body: some View {
    WithViewStore(store, observe: \.entries) { entries in
      Grid {
        if vSize == .regular {
          configurableAverageWidget()
          amountsPlotWidget().gridCellColumns(2)

          GridRow {
            averageTimeBetweenWidget().gridCellColumns(isShowingTrend ? 1 : 2)
            trendWidget()
          }
        } else {
          GridRow {
            amountsPlotWidget().gridCellColumns(isShowingTrend ? 2 : 3)
            trendWidget()
          }

          GridRow {
            averageTimeBetweenWidget()
            configurableAverageWidget().gridCellColumns(2)
          }
        }

        intervalPicker(entries.state.clamp(.alltime))
      }
      .onChange(of: selection) {
        if !Option.enabledCases($0).contains(option) { option = Option.enabledCases($0).first! }
        if !PlotOption.enabledCases($0).contains(plotOption) { plotOption = PlotOption.enabledCases($0).first! }
      }
    }
  }

  @Dependency(\.format) private var format
}

extension StatsView {
  @ViewBuilder private func trendWidget() -> some View {
    if isShowingTrend {
      Widget {
        DescriptedValueContent(
          format.trend(optionTrend), description: Text(option.description) + Text(" ") + Text("(TREND)")
        )
      }
      .transition(.move(edge: .trailing))
    }
  }

  private func configurableAverageWidget() -> some View {
    ConfigurableWidget(selection: $option, enabled: Option.enabledCases(selection)) {
      DescriptedValueContent(format.average(optionAverage), description: $0.description)
    }
  }

  private func averageTimeBetweenWidget() -> some View {
    Widget {
      DescriptedValueContent(format.time(averageTimeBetween), description: "AVERAGE_TIME_BETWEEN")
    }
  }

  private func amountsPlotWidget() -> some View {
    ConfigurableWidget(selection: $plotOption, enabled: PlotOption.enabledCases(selection)) { option in
      AmountsChart(optionPlotData, description: Text(option.description))
    }
  }

  private func intervalPicker(_ bounds: Interval) -> some View {
    Widget {
      IntervalPicker(selection: $selection, bounds: bounds)
        .labelStyle(.iconOnly)
        .buttonStyle(.borderedProminent)
    }
  }
}

#Preview {
  StatisticView()
}
