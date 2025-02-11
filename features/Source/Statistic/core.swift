// Created by Leopold Lemmermann on 04.02.25.

import Calculate
import ComposableArchitecture
import Foundation
import Types

@Reducer public struct Statistic {
  @ObservableState public struct State: Equatable, Sendable {
    @Shared var entries: Dates
    @Shared var selection: Interval
    @Shared var option: StatisticOption
    @Shared var plotOption: PlotOption

    public init(
      entries: Dates = Dates(),
      selection: Interval = .alltime,
      option: StatisticOption = .perday,
      plotOption: PlotOption = .byyear
    ) {
      _entries = Shared(wrappedValue: entries, .fileStorage(.documentsDirectory.appending(path: "entries.json")))
      _selection = Shared(wrappedValue: selection, .fileStorage(.documentsDirectory.appending(path: "stats_selection")))
      _option = Shared(wrappedValue: option, .appStorage("stats_option"))
      _plotOption = Shared(wrappedValue: plotOption, .appStorage("stats_plotOption"))
    }
  }

  @CasePathable public enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
      .onChange(of: \.selection) { _, new in
        Reduce { state, action in
          if case .binding(\.selection) = action {
            return .run { [state] _ in
              if !StatisticOption.enabledCases(new).contains(state.option) {
                guard let option = StatisticOption.enabledCases(new).first else {
                  return assert(false, "no enabled option")
                }
                state.$option.withLock { $0 = option }
              }
              
              if !PlotOption.enabledCases(new).contains(state.plotOption) {
                guard let option = PlotOption.enabledCases(new).first else {
                  return assert(false, "no enabled plot option")
                }
                state.$plotOption.withLock { $0 = option }
              }
            }
          }

          return .none
        }
      }
  }

  public init() {}
}

extension Statistic.State {
  var subdivision: Subdivision { option.subdivision }
  var clampedSelection: Interval { entries.clamp(selection) }
  var bounds: Interval { entries.clamp(.alltime) }

  var optionAverage: Double? {
    @Dependency(\.calculate.average) var average
    return average(clampedSelection, subdivision, entries.array)
  }

  var optionTrend: Double? {
    @Dependency(\.calculate.trend) var trend
    return selection == .alltime ? nil : trend(clampedSelection, subdivision, entries.array)
  }

  var optionPlotData: [Interval: Int]? {
    @Dependency(\.calculate.amounts) var amounts
    return amounts(clampedSelection, plotOption.subdivision, entries.array)
  }

  var averageTimeBetween: TimeInterval {
    @Dependency(\.calculate.averageBreak) var averageBreak
    return averageBreak(clampedSelection, entries.array)
  }

  var showingTrend: Bool { selection != .alltime }
  var enabledOptions: [StatisticOption] { StatisticOption.enabledCases(selection) }
  var enabledPlotOptions: [PlotOption] { PlotOption.enabledCases(selection) }
}
