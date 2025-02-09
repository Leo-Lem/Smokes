// Created by Leopold Lemmermann on 09.02.25.

import ComposableArchitecture
import Testing
import Types

@testable import Statistic

@MainActor
struct StatisticTest {
  @Test(arguments: StatisticOption.allCases)
  func option(option: StatisticOption) async throws {
    let store = TestStore(initialState: Statistic.State(), reducer: Statistic.init) { deps in
      deps.bundle.string = { $0 }
    }

    await store.send(.option(option)) {
      $0.$option.withLock { $0 = option }
    }
  }

  @Test(arguments: PlotOption.allCases)
  func plotOption(plotOption: PlotOption) async throws {
    let store = TestStore(initialState: Statistic.State(), reducer: Statistic.init) { deps in
      deps.bundle.string = { $0 }
    }
    
    await store.send(.plotOption(plotOption)) {
      $0.$plotOption.withLock { $0 = plotOption }
    }
  }

  @Test(arguments: [Interval.alltime, .year(.distantPast), .month(.distantPast)])
  func interval(interval: Interval) async throws {
    let store = TestStore(
      initialState: Statistic.State(option: .permonth, plotOption: .bymonth),
      reducer: Statistic.init
    ) { deps in
      deps.bundle.string = { $0 }
      deps.calendar = .current
    }

    await withDependencies { $0.calendar = .current } operation: {
      await store.send(.select(interval)) {
        $0.$selection.withLock { $0 = interval }
      }

      if case .month = interval {
        await store.receive(\.option) {
            $0.$option.withLock { $0 = .perday }
            $0.$plotOption.withLock { $0 = .byday }
        }
        await store.receive(\.plotOption)
        await store.finish()
      }
    }
  }

  @Test
  func computations() async throws {
    let store = TestStore(
      initialState: Statistic.State(selection: .month(.distantPast)),
      reducer: Statistic.init
    ) { deps in
      deps.bundle.string = { $0 }
    }

    withDependencies { deps in
      deps.date.now = .distantPast
      deps.calendar = .current
      deps.calculate.average = { _, _, _ in 1.0 }
      deps.calculate.trend = { _, _, _ in 1.0 }
      deps.calculate.amounts = { _, _, _ in [Interval.month(.distantPast): 1] }
      deps.calculate.averageBreak = { _, _ in 1.0 }
      deps.format.plotInterval = { _, _, _ in "1" }
    } operation: {
      #expect(store.state.optionAverage == 1.0)
      #expect(store.state.optionTrend == 1.0)
      #expect(store.state.optionPlotData?.first?.0 == "1")
      #expect(store.state.optionPlotData?.first?.1 == 1)
      #expect(store.state.averageTimeBetween == 1.0)
    }
  }

  @Test(arguments: [Interval.alltime, .month(.distantPast), .year(.distantPast)])
  func showingTrend(_ interval: Interval) async throws {
    let store = TestStore(
      initialState: Statistic.State(selection: interval),
      reducer: Statistic.init
    ) { deps in
      deps.bundle.string = { $0 }
    }

    #expect(interval == .alltime || store.state.showingTrend)
  }
}

// TODO: add performance test
