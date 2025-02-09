// Created by Leopold Lemmermann on 04.02.25.

import Bundle
import Calculate
import ComposableArchitecture
import Format
import Foundation
import Types

@Reducer public struct Statistic: Sendable {
  @ObservableState public struct State: Equatable, Sendable {
    @Shared(.fileStorage(FileManager.document_url(
      Dependency(\.bundle.string).wrappedValue("ENTRIES_FILENAME")
    )))
    public var entries = Dates()

    @Shared(.fileStorage(FileManager.document_url("stats_selection"))) var selection = Interval.alltime
    @Shared(.appStorage("stats_option")) var option = StatisticOption.perday
    @Shared(.appStorage("stats_plotOption")) var plotOption = PlotOption.byyear

    public init(
      entries: Dates = Dates(),
      selection: Interval = .alltime,
      option: StatisticOption = .perday,
      plotOption: PlotOption = .byyear
    ) {
      self._entries = Shared(value: entries)
      self._selection = Shared(value: selection)
      self._option = Shared(value: option)
      self._plotOption = Shared(value: plotOption)
    }
  }

  public enum Action: Sendable {
    case option(StatisticOption),
         plotOption(PlotOption),
         select(Interval)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .option(option):
        state.$option.withLock { $0 = option }

      case let .plotOption(option):
        state.$plotOption.withLock { $0 = option }

      case let .select(interval):
        state.$selection.withLock { $0 = interval }
        return .run { [state] send in
          if !StatisticOption.enabledCases(interval).contains(state.option) {
            guard let option = StatisticOption.enabledCases(interval).first else {
              return assert(false, "no enabled option")
            }
            await send(.option(option))
          }

          if !PlotOption.enabledCases(interval).contains(state.plotOption) {
            guard let option = PlotOption.enabledCases(interval).first else {
              return assert(false, "no enabled plot option")
            }
            await send(.plotOption(option))
          }
        }
      }
      return .none
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

  var optionPlotData: [(String, Int)]? {
    @Dependency(\.calculate.amounts) var amounts
    @Dependency(\.format.plotInterval) var plotInterval
    return amounts(clampedSelection, plotOption.subdivision, entries.array)?
      .sorted { $0.key < $1.key }
      .map { (plotInterval($0, selection, plotOption.subdivision) ?? "", $1) }
  }

  var averageTimeBetween: TimeInterval {
    @Dependency(\.calculate.averageBreak) var averageBreak
    return averageBreak(clampedSelection, entries.array)
  }

  var showingTrend: Bool { selection != .alltime }
}
