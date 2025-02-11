// Created by Leopold Lemmermann on 12.03.23.

import Charts
import Components
import ComposableArchitecture
import Extensions
import SwiftUI

public struct StatisticView: View {
  @Bindable public var store: StoreOf<Statistic>

  public var body: some View {
    Grid {
      ConfigurableWidget(selection: $store.option, enabled: store.enabledOptions) {
        DescriptedValueContent(store.optionAverageFormatted, description: $0.description)
      }

      ConfigurableWidget(selection: $store.plotOption, enabled: store.enabledPlotOptions) { option in
        AmountsChart(store.optionPlotDataFormatted, description: Text(option.description))
      }
      .gridCellColumns(2)

      GridRow {
        Widget {
          DescriptedValueContent(store.averageTimeBetweenFormatted,
                                 description: String(localized: "time between smokes"))
        }
        .gridCellColumns(store.showingTrend ? 1 : 2)

        if store.showingTrend {
          Widget {
            DescriptedValueContent(
              store.optionTrendFormatted,
              description: Text(store.option.description) + Text(" ") + Text("(trend)")
            )
          }
          .transition(.move(edge: .trailing))
        }
      }

      Widget {
        IntervalPicker(selection: $store.selection, bounds: store.bounds)
          .labelStyle(.iconOnly)
          .buttonStyle(.borderedProminent)
      }
      .popoverTip(AlltimeTip())
    }
    .animation(.default, values: store.selection)
    .animation(.default, values: store.option)
    .animation(.default, values: store.plotOption)
  }

  public init(store: StoreOf<Statistic>) { self.store = store }
}

fileprivate extension Statistic.State {
  var optionAverageFormatted: Text? {
    @Dependency(\.format) var format
    return format.average(optionAverage)
  }

  var averageTimeBetweenFormatted: Text {
    @Dependency(\.format.time) var time
    return time(averageTimeBetween)
  }

  var optionTrendFormatted: Text? {
    @Dependency(\.format) var format
    return format.trend(optionTrend)
  }

  var optionPlotDataFormatted: [(String, Int)]? {
    @Dependency(\.format.plotInterval) var plotInterval
    return optionPlotData?
      .sorted { $0.key < $1.key }
      .map { (plotInterval($0, selection, plotOption.subdivision) ?? "", $1) }
  }
}

#Preview {
  StatisticView(store: Store(initialState: Statistic.State(), reducer: Statistic.init))
}
