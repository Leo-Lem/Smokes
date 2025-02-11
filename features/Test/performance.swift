// Created by Leopold Lemmermann on 09.02.25.

import ComposableArchitecture
import XCTest

@testable import Statistic

@MainActor
class Performance: XCTestCase {
  func testStatistic() {
    let dates: [Date] = (0...10_000_000).map { Date(timeIntervalSinceReferenceDate: TimeInterval($0)) }
    let store = TestStore(
      initialState: Statistic.State(entries: .init(dates)),
      reducer: Statistic.init
    )

    withDependencies { deps in
      deps.calculate = .liveValue
      deps.calendar = .current
      deps.date.now = .distantFuture
    } operation: {
      self.measure {
        _ = store.state.optionAverage
        _ = store.state.optionTrend
        _ = store.state.averageTimeBetween
      }
    }
  }

  // TODO: improve performance
  func testStatisticPlotData() {
    let dates: [Date] = (0...10_000).map { Date(timeIntervalSinceReferenceDate: TimeInterval($0)) }
    let store = TestStore(
      initialState: Statistic.State(entries: .init(dates)),
      reducer: Statistic.init
    )

    withDependencies { deps in
      deps.calculate = .liveValue
      deps.calendar = .current
      deps.date.now = .distantFuture
    } operation: {
      self.measure {
        _ = store.state.optionPlotData
      }
    }
  }
}
