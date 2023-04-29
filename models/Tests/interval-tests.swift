// Created by Leopold Lemmermann on 02.04.23.

@testable import SmokesModels
import XCTest

@MainActor
final class IntervalTests: XCTestCase {
  private let cal = Calendar.current
  private let now = Date.now
  
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
      Interval.day(now).next(in: Interval.day(cal.date(byAdding: .day, value: 2, to: now)!)),
      Interval.day(cal.date(byAdding: .day, value: 1, to: now)!)
    )
  }
      
  func test_givenUpperBoundReached_whenGettingNext_thenReturnsNil() throws {
    XCTAssertNil(Interval.day(now).next(in: Interval.day(now)))
  }
      
  func test_givenLowerBoundNotReached_whenGettingPrevious_thenReturnsCorrect() throws {
    XCTAssertEqual(
      Interval.day(now).previous(in: Interval.day(cal.date(byAdding: .day, value: -2, to: now)!)),
      Interval.day(cal.date(byAdding: .day, value: -1, to: now)!)
    )
  }
      
  func test_givenLowerBoundReached_whenGettingPrevious_thenReturnsNil() throws {
    XCTAssertNil(Interval.day(now).previous(in: Interval.day(now)))
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
      case (.month, .day): return 30
      case (.month, .week): return 4
      case (.year, .day): return 365
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
  
  func test_givenIsUncountable_whenCounting_thenReturnsNil() async throws {
    for interval in intervals where !interval.isCountable {
      for subdivision in Subdivision.allCases {
        XCTAssertNil(interval.count(by: subdivision))
      }
    }
  }
  
  func test_givenIsCountable_whenEnumerating_thenReturns() async throws {
    for interval in intervals where interval.isCountable {
      for subdivision in Subdivision.allCases where Subdivision(interval).flatMap({ subdivision < $0 }) ?? true {
        XCTAssertNotNil(interval.enumerate(by: subdivision))
      }
    }
  }
  
  func test_givenIsUncountable_whenEnumerating_thenReturnsNil() async throws {
    for interval in intervals where !interval.isCountable {
      for subdivision in Subdivision.allCases {
        XCTAssertNil(interval.enumerate(by: subdivision))
      }
    }
  }
}

extension IntervalTests {
  private var intervals: Set<Interval> {
    [
      .from(now), .to(now), .alltime,
      .day(now), .week(now), .month(now), .year(now),
      .fromTo(.init(start: now, duration: 999_999))
    ]
  }
}
