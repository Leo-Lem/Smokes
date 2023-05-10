// Created by Leopold Lemmermann on 12.03.23.

import Charts
import ComposableArchitecture
import struct SmokesReducers.Entries
import SwiftUI

struct StatsView: View {
  @EnvironmentObject private var store: StoreOf<App>

  var body: some View {
    WithViewStore(store, observe: \.entries) { entries in
      let clampedSelection = plotOption.clamp(entries.state.clamp(selection))

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
        entries.array, selection, option, plotOption, optionAverage, optionTrend, averageTimeBetween)
      .onChange(of: selection) {
        if !Option.enabledCases($0).contains(option) { option = Option.enabledCases($0).first! }
        if !PlotOption.enabledCases($0).contains(plotOption) { plotOption = PlotOption.enabledCases($0).first! }
      }
      .onChange(of: clampedSelection) { _ in
        optionAverage = nil
        optionTrend = nil
        averageTimeBetween = nil
        optionPlotData = nil
      }
      .task(id: clampedSelection) {
        optionAverage = calculate.average(clampedSelection, option.subdivision, entries.array)
        optionTrend = selection == .alltime ? nil : calculate.trend(clampedSelection, option.subdivision, entries.array)
        averageTimeBetween = calculate.averageBreak(clampedSelection, entries.array)
        optionPlotData = calculate.amounts(clampedSelection, plotOption.subdivision, entries.array)?
          .sorted { $0.key < $1.key }
          .map { (format.plotInterval($0, selection, plotOption.subdivision) ?? "", $1) }
      }
      .onChange(of: entries.array) { _ in
        optionAverage = nil
        optionTrend = nil
        averageTimeBetween = nil
        optionPlotData = nil
      }
      .task(id: entries.array) {
        optionAverage = calculate.average(clampedSelection, option.subdivision, entries.array)
        optionTrend = selection == .alltime ? nil : calculate.trend(clampedSelection, option.subdivision, entries.array)
        averageTimeBetween = calculate.averageBreak(clampedSelection, entries.array)
        optionPlotData = calculate.amounts(clampedSelection, plotOption.subdivision, entries.array)?
          .sorted { $0.key < $1.key }
          .map { (format.plotInterval($0, selection, plotOption.subdivision) ?? "", $1) }
      }
      .onChange(of: option) { _ in
        optionAverage = nil
        optionTrend = nil
        averageTimeBetween = nil
      }
      .task(id: option) {
        optionAverage = calculate.average(clampedSelection, option.subdivision, entries.array)
        optionTrend = selection == .alltime ? nil : calculate.trend(clampedSelection, option.subdivision, entries.array)
        averageTimeBetween = calculate.averageBreak(clampedSelection, entries.array)
      }
      .onChange(of: plotOption) { _ in
        optionPlotData = nil
      }
      .task(id: plotOption) {
        optionPlotData = calculate.amounts(clampedSelection, plotOption.subdivision, entries.array)?
          .sorted { $0.key < $1.key }
          .map { (format.plotInterval($0, selection, plotOption.subdivision) ?? "", $1) }
      }
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
