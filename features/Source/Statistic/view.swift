// Created by Leopold Lemmermann on 12.03.23.

import Charts
import Components
import ComposableArchitecture
import Extensions
import SwiftUI
import enum Generated.L10n

public struct StatisticView: View {
  @ComposableArchitecture.Bindable public var store: StoreOf<Statistic>

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
        IntervalPicker(selection: $store.selection, bounds: store.bounds)
          .labelStyle(.iconOnly)
          .buttonStyle(.borderedProminent)
      }
    }
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

extension StatisticOption: RawRepresentable, ConfigurableWidgetOption {
  public static let allCases = [Self.perday, .perweek, .permonth, .peryear]

  public init?(rawValue: String) {
    switch rawValue {
    case L10n.Statistic.daily: self = .perday
    case L10n.Statistic.weekly: self = .perweek
    case L10n.Statistic.monthly: self = .permonth
    case L10n.Statistic.yearly: self = .peryear
    default: return nil
    }
  }

  public var rawValue: String {
    switch self {
    case .perday: L10n.Statistic.daily
    case .perweek: L10n.Statistic.weekly
    case .permonth: L10n.Statistic.monthly
    case .peryear: L10n.Statistic.yearly
    }
  }
}

extension PlotOption: RawRepresentable, ConfigurableWidgetOption {
  public static let allCases = [Self.byday, .byweek, .bymonth, .byyear]

  public init?(rawValue: String) {
    switch rawValue {
    case L10n.Plot.daily: self = .byday
    case L10n.Plot.weekly: self = .byweek
    case L10n.Plot.monthly: self = .bymonth
    case L10n.Plot.yearly: self = .byyear
    default: return nil
    }
  }

  public var rawValue: String {
    switch self {
    case .byday: L10n.Plot.daily
    case .byweek: L10n.Plot.weekly
    case .bymonth: L10n.Plot.monthly
    case .byyear: L10n.Plot.yearly
    }
  }
}

#Preview {
  StatisticView(store: Store(initialState: Statistic.State(), reducer: Statistic.init))
}
