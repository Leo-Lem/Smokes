// Created by Leopold Lemmermann on 02.04.23.

import XCTest

@testable import Types

// TODO: update to use swift testing
final class IntervalTests: XCTestCase {
  private let cal = {
    var cal = Calendar.current
    cal.timeZone = .gmt
    return cal
  }()

  private let date = Date(timeIntervalSinceReferenceDate: 9_999_999)
  
  func test_givenIsCountable_whenGettingDuration_thenReturnsCorrect() throws {
    for interval in intervals where interval.isCountable {
      XCTAssertEqual(interval.duration, interval.start?.distance(to: interval.end!))
    }
  }
  
  func test_givenIsUncountable_whenGettingDuration_thenReturnsInfinity() throws {
    for interval in intervals where !interval.isCountable {
      XCTAssertEqual(interval.duration, .infinity)
    }
  }
      
  func test_givenUpperBoundNotReached_whenGettingNext_thenReturnsCorrect() throws {
    XCTAssertEqual(
      Interval.day(date).next(in: Interval.day(cal.date(byAdding: .day, value: 2, to: date)!)),
      Interval.day(cal.date(byAdding: .day, value: 1, to: date)!)
    )
  }
      
  func test_givenUpperBoundReached_whenGettingNext_thenReturnsNil() throws {
    XCTAssertNil(Interval.day(date).next(in: Interval.day(date)))
  }
      
  func test_givenLowerBoundNotReached_whenGettingPrevious_thenReturnsCorrect() throws {
    XCTAssertEqual(
      Interval.day(date).previous(in: Interval.day(cal.date(byAdding: .day, value: -2, to: date)!)),
      Interval.day(cal.date(byAdding: .day, value: -1, to: date)!)
    )
  }
      
  func test_givenLowerBoundReached_whenGettingPrevious_thenReturnsNil() throws {
    XCTAssertNil(Interval.day(date).previous(in: Interval.day(date)))
  }
      
  func test_givenIsCountable_whenCounting_thenReturnsCorrect() throws {
    for interval in intervals where interval.isCountable {
      for subdivision in Subdivision.allCases where Subdivision(interval).flatMap({ subdivision < $0 }) ?? true {
        if let count = interval.count(by: subdivision) {
          XCTAssertEqual(count, expected(interval, subdivision))
        }
      }
    }
    
    func expected(_ interval: Interval, _ subdivision: Subdivision) -> Int {
      switch (interval, subdivision) {
      case _ where Subdivision(interval) == subdivision: return 1
      case (.week, .day): return 6
      case (.month, .day): return 29
      case (.month, .week): return 4
      case (.year, .day): return 364
      case (.year, .week): return 52
      case (.year, .month): return 11
      case (.fromTo, .day): return 11
      case (.fromTo, .week): return 1
      case (.fromTo, _): break
      default: XCTFail("Invalid combination \(interval) \(subdivision)")
      }
      
      return 0
    }
  }
  
  func test_givenIsUncountable_whenCounting_thenReturnsMax() throws {
    for interval in intervals where !interval.isCountable {
      for subdivision in Subdivision.allCases {
        XCTAssertEqual(interval.count(by: subdivision), .max)
      }
    }
  }
  
  func test_givenIsCountable_whenEnumerating_thenReturns() throws {
    for interval in intervals where interval.isCountable {
      for subdivision in Subdivision.allCases where Subdivision(interval).flatMap({ subdivision < $0 }) ?? true {
        XCTAssertNotNil(interval.enumerate(by: subdivision))
      }
    }
  }
  
  func test_givenIsUncountable_whenEnumerating_thenReturnsNil() throws {
    for interval in intervals where !interval.isCountable {
      for subdivision in Subdivision.allCases {
        XCTAssertNil(interval.enumerate(by: subdivision))
      }
    }
  }
  
  func test_givenContainsDate_whenContains_thenReturnsTrue() throws {
    for interval in intervals { XCTAssertTrue(interval.contains(date)) }
  }
  
  func test_givenDoesNotContainDate_whenContains_thenReturnsFalse() throws {
    for interval in intervals where interval.start != nil {
      XCTAssertFalse(interval.contains(.distantPast))
    }
  }
  
  func test_givenContainsInterval_whenContains_thenReturnsTrue() throws {
    for interval in intervals {
      XCTAssertTrue(interval.contains(.fromTo(.init(start: date, duration: 0))), "\(interval)")
    }
  }
  
  func test_givenDoesNotContainInterval_whenContains_thenReturnsFalse() throws {
    for interval in intervals where interval.end != nil {
      XCTAssertFalse(interval.contains(.from(.distantFuture)))
    }
  }
}

extension IntervalTests {
  private var intervals: Set<Interval> {
    [
      .from(date), .to(date), .alltime,
      .day(date), .week(date), .month(date), .year(date),
      .fromTo(.init(start: date, duration: 999_999))
    ]
  }
}
