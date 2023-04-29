// Created by Leopold Lemmermann on 12.03.23.

import Charts
import ComposableArchitecture
import SwiftUI

struct StatsView: View {
  @EnvironmentObject private var store: StoreOf<App>

  var body: some View {
    WithViewStore(store) {
      ViewState($0, selection: selection, option: option, plotOption: plotOption)
    } content: { vs in
      Grid {
        if vSize == .regular {
          configurableAverageWidget(vs)
          amountsPlotWidget(vs).gridCellColumns(2)

          GridRow {
            averageTimeBetweenWidget(vs).gridCellColumns(isShowingTrend ? 1 : 2)
            trendWidget(vs)
          }
        } else {
          GridRow {
            amountsPlotWidget(vs).gridCellColumns(2)
            averageTimeBetweenWidget(vs)
          }

          GridRow {
            trendWidget(vs)
            configurableAverageWidget(vs).gridCellColumns(isShowingTrend ? 2 : 3)
          }
        }

        intervalPicker(vs)
      }
      .animation(.default, value: vs.state)
      .animation(.default, value: selection)
      .animation(.default, value: option)
      .animation(.default, value: plotOption)
    }
  }

  @CodableAppStorage("stats_selection") private var selection = Interval.alltime
  @AppStorage("stats_option") private var option = Option.perday
  @AppStorage("stats_plotOption") private var plotOption = PlotOption.byyear

  @Environment(\.verticalSizeClass) private var vSize
  @Dependency(\.format) private var format
  
  private var isShowingTrend: Bool { selection != .alltime }
}

extension StatsView {
  @ViewBuilder private func trendWidget(_ vs: ViewStore<ViewState, App.Action>) -> some View {
    if isShowingTrend {
      Widget {
        DescriptedValueContent(
          format.trend(vs.optionTrend), description: Text(option.description)
          + Text(" ") + Text("(TREND)")
        )
      }
      .transition(.move(edge: vSize == .regular ? .trailing : .leading))
    }
  }

  private func configurableAverageWidget(_ vs: ViewStore<ViewState, App.Action>) -> some View {
    ConfigurableWidget(selection: $option, enabled: Option.enabledCases(selection)) {
      DescriptedValueContent(format.average(vs.optionAverage), description: $0.description)
    }
  }

  private func averageTimeBetweenWidget(_ vs: ViewStore<ViewState, App.Action>) -> some View {
    Widget {
      DescriptedValueContent(format.time(vs.averageTimeBetween), description: "AVERAGE_TIME_BETWEEN")
    }
  }

  private func amountsPlotWidget(_ vs: ViewStore<ViewState, App.Action>) -> some View {
    ConfigurableWidget(selection: $plotOption, enabled: PlotOption.enabledCases(selection)) { _ in
      Text("COMING_SOON").frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
  
  private func intervalPicker(_ vs: ViewStore<ViewState, App.Action>) -> some View {
    Widget {
      IntervalPicker(selection: $selection, bounds: vs.bounds)
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
