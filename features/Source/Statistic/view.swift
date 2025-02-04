// Created by Leopold Lemmermann on 12.03.23.

import Charts
import Components
import ComposableArchitecture
import Extensions
import SwiftUI

public struct StatisticView: View {
  @ComposableArchitecture.Bindable var store: StoreOf<Statistic>

  public var body: some View {
    Grid {
      ConfigurableWidget(
        selection: $store.option.sending(\.option),
        enabled: StatisticOption.enabledCases(store.selection)
      ) {
        DescriptedValueContent(store.optionAverageFormatted, description: $0.description)
      }

      ConfigurableWidget(
        selection: $store.plotOption.sending(\.plotOption),
        enabled: PlotOption.enabledCases(store.selection)
      ) { option in
        AmountsChart(store.optionPlotData, description: Text(option.description))
      }
      .gridCellColumns(2)

      GridRow {
        Widget {
          DescriptedValueContent(store.averageTimeBetweenFormatted, description: "AVERAGE_TIME_BETWEEN")
        }
        .gridCellColumns(store.showingTrend ? 1 : 2)

        if store.showingTrend {
          Widget {
            DescriptedValueContent(
              store.optionTrendFormatted,
              description: Text(store.option.description) + Text(" ") + Text("(TREND)")
            )
          }
          .transition(.move(edge: .trailing))
        }
      }

      Widget {
        IntervalPicker(selection: $store.selection.sending(\.select), bounds: store.bounds)
          .labelStyle(.iconOnly)
          .buttonStyle(.borderedProminent)
      }
    }
  }

  public init(store: StoreOf<Statistic>) { self.store = store }
}

extension Statistic.State {
  fileprivate var optionAverageFormatted: Text? {
    @Dependency(\.format) var format
    return format.average(optionAverage)
  }

  fileprivate var averageTimeBetweenFormatted: Text {
    @Dependency(\.format) var format
    return format.time(averageTimeBetween)
  }

  fileprivate var optionTrendFormatted: Text? {
    @Dependency(\.format) var format
    return format.trend(optionTrend)
  }
}

#Preview {
  StatisticView(store: Store(initialState: Statistic.State(), reducer: Statistic.init))
}
