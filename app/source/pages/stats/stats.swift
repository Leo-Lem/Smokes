// Created by Leopold Lemmermann on 12.03.23.

import Charts
import ComposableArchitecture
import SwiftUI

struct StatsView: View {
  @EnvironmentObject private var store: StoreOf<App>

  var body: some View {
    WithViewStore(store) { ViewState($0, interval: selection) } send: { ViewAction.send($0) } content: { vs in
      Grid {
        if vSize == .regular {
          configurableAverageWidget(vs)
          amountsPlotWidget(vs).gridCellColumns(2)

          GridRow {
            averageTimeBetweenWidget(vs)
            trendWidget(vs)
          }
        } else {
          GridRow {
            amountsPlotWidget(vs).gridCellColumns(2)
            averageTimeBetweenWidget(vs)
          }

          GridRow {
            trendWidget(vs)
            configurableAverageWidget(vs).gridCellColumns(2)
          }
        }

        intervalPicker(vs)
      }
      .animation(.default, value: vs.state)
      .animation(.default, value: selection)
      .animation(.default, value: option)
      .animation(.default, value: plotOption)
      .onAppear { ViewAction.update(vs, selection: selection, option: option) }
      .onChange(of: selection) {
        ViewAction.update(vs, selection: $0, option: option)
        if !Option.enabledCases($0).contains(option) { option = Option.enabledCases(selection).first! }
        if !PlotOption.enabledCases($0).contains(plotOption) { plotOption = PlotOption.enabledCases(selection).first! }
      }
      .onChange(of: option) { ViewAction.update(vs, selection: selection, option: $0) }
    }
  }

  @CodableAppStorage("stats_selection") private var selection = Interval.alltime
  @AppStorage("stats_option") private var option = Option.perday
  @AppStorage("stats_plotOption") private var plotOption = PlotOption.byyear

  @Environment(\.verticalSizeClass) private var vSize
  @Dependency(\.formatter) private var formatter
}

extension StatsView {
  private func trendWidget(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    Widget {
      DescriptedValueContent(
        formatter.format(trend: vs.configurableTrends[option]), description: Text(option.description)
          + Text(" ") + Text("(TREND)")
      )
    }
  }

  private func configurableAverageWidget(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    ConfigurableWidget(selection: $option, enabled: Option.enabledCases(selection)) {
      DescriptedValueContent(formatter.format(average: vs.configurableAverages[$0]), description: $0.description)
    }
  }

  private func averageTimeBetweenWidget(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    Widget {
      DescriptedValueContent(formatter.format(time: vs.averageTimeBetween), description: "AVERAGE_TIME_BETWEEN")
    }
  }

  private func amountsPlotWidget(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    ConfigurableWidget(selection: $plotOption, enabled: PlotOption.enabledCases(selection)) { _ in
      
    }
  }
  
  private func intervalPicker(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
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
