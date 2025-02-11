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
        LoadableWithDescription(
          store.optionAverage.flatMap{ $0.isFinite ? "\($0, format: .average) smokes" : "No data" },
          description: $0.description
        )
      }

      ConfigurableWidget(selection: $store.plotOption, enabled: store.enabledPlotOptions) { option in
        LoadableWithDescription(
          store.optionPlotData?
            .sorted(by: \.key)
            .map { ($0.formatted(.interval(bounds: store.selection, subdivision: store.subdivision)), $1) },
          description: option.description
        ) {
          AmountsChart($0)
        }
      }
      .gridCellColumns(2)

      GridRow {
        Widget {
          LoadableWithDescription(
            store.averageTimeBetween.isFinite ? "\(store.averageTimeBetween, format: .timeInterval)" : "No Data",
            description: "time between smokes"
          )
        }
        .gridCellColumns(store.showingTrend ? 1 : 2)

        if store.showingTrend {
          Widget {
            LoadableWithDescription(
              store.optionTrend.flatMap { $0.isFinite ? "\($0, format: .trend) smokes" : "No data" },
              description: "\(store.option.description) \(String(localized: "(trend)"))"
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
    .animation(.default, values: CombineHashable(store.selection, store.option, store.plotOption))
  }

  public init(store: StoreOf<Statistic>) { self.store = store }
}

#Preview {
  StatisticView(store: Store(initialState: Statistic.State(), reducer: Statistic.init))
    .padding()
}
