// Created by Leopold Lemmermann on 09.02.25.

@testable import Calculate
import ComposableArchitecture
@testable import Statistic
@testable import Types
import XCTest

class Performance: XCTestCase {
  let entries: [Date] = (0...10_000_000).map { Date(timeIntervalSinceReferenceDate: TimeInterval($0)) }

  func testStatisticPlotData() {
    let store = TestStore(
      initialState: Statistic.State(entries: Dates(entries)),
      reducer: Statistic.init
    )

    withDependencies { deps in
      deps.calculate = .liveValue
      deps.calendar = .current
      deps.date.now = .now
    } operation: {
      measure {
        _ = store.state.optionPlotData
      }
    }
  }

  func testCalculateAmounts() {
    let calculate = Calculate.liveValue

    measure {
      _ = calculate.amounts(.alltime, .day, entries)
    }
  }

  func testClampDates() {
    let dates = Dates(entries)

    withDependencies {
      $0.calendar = .current
      $0.date.now = .now
    } operation: {
      measure {
        _ = dates.clamp(.fromTo(DateInterval(start: .now.advanced(by: -1_0000_000), end: .now)))
      }
    }
  }

  func testEntriesToArray() {
    let dates = Dates(entries)
    
    measure {
      _ = dates.array
    }
  }
}
