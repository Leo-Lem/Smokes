// Created by Leopold Lemmermann on 12.03.23.

import Charts
import ComposableArchitecture
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
            amountsPlotWidget().gridCellColumns(2)
            averageTimeBetweenWidget()
          }

          GridRow {
            trendWidget()
            configurableAverageWidget().gridCellColumns(isShowingTrend ? 2 : 3)
          }
        }

        intervalPicker(entries.state.clamp(.alltime))
      }
      .animation(.default, value: CombineHashable(
        entries.array, selection, option, plotOption, optionAverage, optionTrend, optionPlotData, averageTimeBetween
      ))
      .onChange(of: option) { update($0, entries.state.clamp(selection), entries.array) }
      .onChange(of: selection) {
        update(option, entries.state.clamp($0), entries.array)
        if !Option.enabledCases($0).contains(option) { option = Option.enabledCases(selection).first! }
        if !PlotOption.enabledCases($0).contains(plotOption) { plotOption = PlotOption.enabledCases(selection).first! }
      }
      .onChange(of: entries.array) { update(option, entries.state.clamp(selection), $0) }
      .task { await updatePlotData(entries.state.clamp(selection), entries.array) }
      .task(id: CombineHashable(selection, plotOption, option, entries.array)) {
        await updatePlotData(entries.state.clamp(selection), entries.array)
      }
    }
  }

  @CodableAppStorage("stats_selection") private var selection = Interval.alltime
  @AppStorage("stats_option") private var option = Option.perday
  @AppStorage("stats_plotOption") private var plotOption = PlotOption.byyear
  
  @State private var optionAverage: Double?
  @State private var optionTrend: Double?
  @State private var optionPlotData: [Interval: Int]?
  @State private var averageTimeBetween: TimeInterval?

  @Environment(\.verticalSizeClass) private var vSize
  @Dependency(\.format) private var format
  @Dependency(\.calculate) private var calculate

  private var isShowingTrend: Bool { selection != .alltime }
}

private extension StatsView {
  func update(_ option: Option, _ selection: Interval, _ entries: [Date]) {
    optionAverage = calculate.average(selection, option.subdivision, entries)
    optionTrend = selection == .alltime ? nil : calculate.trend(selection, option.subdivision, entries)
    averageTimeBetween = calculate.averageBreak(selection, entries)
  }
  
  func updatePlotData(_ selection: Interval, _ entries: [Date]) async {
    optionPlotData = await calculate.amounts(selection, plotOption.subdivision, entries)
  }
}

extension StatsView {
  @ViewBuilder private func trendWidget() -> some View {
    if isShowingTrend {
      Widget {
        DescriptedValueContent(
          format.trend(optionTrend), description: Text(option.description)
            + Text(" ") + Text("(TREND)")
        )
      }
      .transition(.move(edge: vSize == .regular ? .trailing : .leading))
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
      AmountsChart(
        optionPlotData?
          .sorted { $0.key < $1.key }
          .map { (format.plotInterval($0, bounds: selection, sub: option.subdivision) ?? "", $1) },
        description: Text(option.description)
      )
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
