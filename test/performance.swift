// Created by Leopold Lemmermann on 09.02.25.

@testable import Calculate
import ComposableArchitecture
@testable import Statistic
@testable import Types
import XCTest

class Performance: XCTestCase {
  let entries = Dates((0...1_000_000).map { Date(timeIntervalSinceReferenceDate: TimeInterval($0)*1000) })

//  func testStatisticPlotData() {
//    let store = TestStore(
//      initialState: Statistic.State(entries: entries, selection: .alltime, plotOption: .byday),
//      reducer: Statistic.init
//    )
//
//    withDependencies { deps in
//      deps.calculate = .liveValue
//      deps.calendar = .current
//      deps.date.now = .now
//    } operation: {
//      measure {
//        _ = store.state.optionPlotData
//      }
//    }
//  }
//
//  func testCalculateAmounts() {
//    withDependencies {
//      $0.calendar = .current
//      $0.date.now = .now
//    } operation: {
//      let calculate = Calculate.liveValue
//      let interval = entries.clamp(.alltime)
//      let array = entries.array
//
//      measure {
//        _ = calculate.amounts(interval, .day, array)
//      }
//    }
//  }

  func testIntervalEnumerate() {
    withDependencies {
      $0.calendar = .current
      $0.date.now = .now
    } operation: {
      let interval = entries.clamp(.alltime)

      measure {
        _ = interval.enumerate(by: .day)
      }
    }
  }

  func testClampDates() {
    withDependencies {
      $0.calendar = .current
      $0.date.now = .now
    } operation: {
      measure {
        _ = entries.clamp(.alltime)
      }
    }
  }

  func testEntriesToArray() {
    measure {
      _ = entries.array
    }
  }
}
