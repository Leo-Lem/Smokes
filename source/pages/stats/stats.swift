// Created by Leopold Lemmermann on 12.03.23.

import Charts
import ComposableArchitecture
import SwiftUI

// FIXME: when selecting last month, crashes sometimes

struct StatsView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store) { ViewState($0, interval: selection) } send: { ViewAction.send($0) } content: { vs in
      Grid {
        if vSize == .regular {
          configurableAverageWidget { vs.configurableAverages[$0.subdivision]?.optional }
          amountsPlotWidget(vs.configurableEntries[plotOption.subdivision]?.optional, bounds: vs.bounds)
            .gridCellColumns(2)

          GridRow {
            averageTimeBetweenWidget(vs.averageTimeBetween)
            trendWidget(vs.configurableTrends[option.subdivision]?.optional)
          }
        } else {
          GridRow {
            amountsPlotWidget(vs.configurableEntries[plotOption.subdivision]?.optional, bounds: vs.bounds)
              .gridCellColumns(2)
            averageTimeBetweenWidget(vs.averageTimeBetween)
          }

          GridRow {
            trendWidget(vs.configurableTrends[option.subdivision]?.optional)
            configurableAverageWidget { vs.configurableAverages[$0.subdivision]?.optional }.gridCellColumns(2)
          }
        }

        intervalPicker($selection, bounds: vs.bounds)
      }
      .animation(.default, value: vs.state)
      .animation(.default, value: selection)
      .animation(.default, value: option)
      .animation(.default, value: plotOption)
      .onAppear {
        vs.send(.loadAverage(selection))
        Option.enabledCases(selection).forEach { vs.send(.loadTrend($0.subdivision, interval: selection)) }
      }
      .onChange(of: selection) { newInterval in
        vs.send(.loadAverage(newInterval))
        
        Option.enabledCases(newInterval).forEach { vs.send(.loadTrend($0.subdivision, interval: newInterval)) }
        if !Option.enabledCases(newInterval).contains(option) {
          option = Option.enabledCases(newInterval).first!
        }
        
        if !PlotOption.enabledCases(newInterval).contains(plotOption) {
          plotOption = PlotOption.enabledCases(newInterval).first!
        }
      }
    }
  }

  @CodableAppStorage("stats_selection") private var selection = Interval.alltime
  @AppStorage("stats_option") private var option = Option.perday
  @AppStorage("stats_plotOption") private var plotOption = PlotOption.byyear

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
    ConfigurableWidget(selection: $option, enabled: Option.enabledCases(selection)) { option in
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

  private func amountsPlotWidget(_ entries: [Date]?, bounds: Interval) -> some View {
    ConfigurableWidget(selection: $plotOption, enabled: PlotOption.enabledCases(selection)) { option in
      AmountsChart(
        entries: entries,
        bounds: selection == .alltime ? bounds : selection,
        subdivision: option.subdivision,
        description: Text(plotOption.description)
      )
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
