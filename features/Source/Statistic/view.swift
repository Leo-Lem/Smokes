// Created by Leopold Lemmermann on 12.03.23.

import Charts
import Components
import ComposableArchitecture
import Extensions

public struct StatisticView: View {
  @Bindable public var store: StoreOf<Statistic>

  public var body: some View {
    Grid {
      LoadableWithDescription(
        store.optionAverage.flatMap{ $0.isFinite ? "\($0.formatted(.average)) smokes" : "No data" },
        description: store.option.rawValue
      )
      .widgetStyle($store.option, enabled: store.enabledOptions)

      LoadableWithDescription(
        store.optionPlotData?
          .sorted(by: \.key)
          .map { ($0.formatted(.interval(bounds: store.selection, subdivision: store.subdivision)), $1) },
        description: store.plotOption.rawValue
      ) {
        AmountsChart($0)
      }
      .widgetStyle($store.plotOption, enabled: store.enabledPlotOptions)
      .gridCellColumns(2)

      GridRow {
        LoadableWithDescription(
          store.averageTimeBetween.isFinite ? store.averageTimeBetween.formatted(.timeInterval) : "No Data",
          description: "time between smokes"
        )
        .widgetStyle()
        .gridCellColumns(store.showingTrend ? 1 : 2)

        if store.showingTrend {
          LoadableWithDescription(
            store.optionTrend.flatMap { $0.isFinite ? "\($0.formatted(.trend)) smokes" : "No data" },
            description: "\(store.option.rawValue) (trend)"
          )
          .widgetStyle()
          .transition(.move(edge: .trailing))
        }
      }

      IntervalPicker(selection: $store.selection, bounds: store.bounds)
        .labelStyle(.iconOnly)
        .buttonStyle(.borderedProminent)
        .widgetStyle()
        .popoverTip(AlltimeTip())
    }
    .animation(.default, value: .combine(store.selection, store.option, store.plotOption))
  }

  public init(store: StoreOf<Statistic>) { self.store = store }
}

#Preview {
  StatisticView(store: Store(initialState: Statistic.State(), reducer: Statistic.init))
    .padding()
}
