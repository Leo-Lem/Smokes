// Created by Leopold Lemmermann on 12.03.23.

import Charts
import ComposableArchitecture
import struct SmokesReducers.Entries
import SwiftUI

struct StatsView: View {
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
      .animation(.default, values:
        entries.array,
        selection, entries.state.clamp(selection), plotOption.clamp(entries.state.clamp(selection)),
        option, plotOption, optionAverage, optionTrend, averageTimeBetween)
      .onChange(of: selection) {
        if !Option.enabledCases($0).contains(option) { option = Option.enabledCases($0).first! }
        if !PlotOption.enabledCases($0).contains(plotOption) { plotOption = PlotOption.enabledCases($0).first! }
      }
      .onChange(of: entries.state.clamp(selection)) { updateOption($0, entries.array) }
      .onChange(of: plotOption.clamp(entries.state.clamp(selection))) { updatePlot($0, entries.array) }
      .onChange(of: entries.array) {
        updateOption(entries.state.clamp(selection), $0)
        updatePlot(plotOption.clamp(entries.state.clamp(selection)), $0)
      }
      .task(id: option) { updateOption(entries.state.clamp(selection), entries.array) }
      .task(id: plotOption) { updatePlot(plotOption.clamp(entries.state.clamp(selection)), entries.array) }
    }
  }

  @CodableAppStorage("stats_selection") private var selection = Interval.alltime
  @AppStorage("stats_option") private var option = Option.perday
  @AppStorage("stats_plotOption") private var plotOption = PlotOption.byyear

  @State private var optionAverage: Double?
  @State private var optionTrend: Double?
  @State private var optionPlotData: [(String, Int)]?
  @State private var averageTimeBetween: TimeInterval?

  @Environment(\.verticalSizeClass) private var vSize
  @Dependency(\.format) private var format
  @Dependency(\.calculate) private var calculate

  private var isShowingTrend: Bool { selection != .alltime }
}

private extension StatsView {
  private func updateOption(_ clampedSelection: Interval, _ entries: [Date]) {
    optionAverage = nil
    optionTrend = nil
    averageTimeBetween = nil

    optionAverage = calculate.average(clampedSelection, option.subdivision, entries)
    optionTrend = selection == .alltime ? nil : calculate.trend(clampedSelection, option.subdivision, entries)
    averageTimeBetween = calculate.averageBreak(clampedSelection, entries)
  }

  private func updatePlot(_ clampedSelection: Interval, _ entries: [Date]) {
    optionPlotData = nil
    optionPlotData = calculate.amounts(clampedSelection, plotOption.subdivision, entries)?
      .sorted { $0.key < $1.key }
      .map { (format.plotInterval($0, selection, plotOption.subdivision) ?? "", $1) }
  }
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
    .environmentObject(Store(initialState: .init(), reducer: App()))
  }
}
#endif
