// Created by Leopold Lemmermann on 02.04.23.

import Dependencies
import Foundation
import Testing
@testable import Types

private let date = Date(timeIntervalSinceReferenceDate: 0)

fileprivate extension Interval {
  static let allCases: Set<Interval> = [
    .alltime, .from(date), .to(date), .day(date), .week(date), .month(date), .year(date),
    .fromTo(.init(start: date, duration: 999_999))
  ]

  var isUncountable: Bool { !isCountable }
  var hasStart: Bool { start != nil }
  var hasEnd: Bool { end != nil }
}

struct IntervalTests {
  var cal: Calendar {
    var cal = Calendar.current
    cal.timeZone = .gmt
    return cal
  }

  @Test(arguments: Interval.allCases.filter(\.isCountable))
  func givenIsCountable_whenGettingDuration_thenReturnsCorrect(interval: Interval) async throws {
    withDependencies { $0.calendar = cal } operation: {
      #expect(interval.duration == interval.start?.distance(to: interval.end!))
    }
  }

  @Test(arguments: Interval.allCases.filter(\.isUncountable))
  func givenIsUncountable_whenGettingDuration_thenReturnsInfinity(interval: Interval) async throws {
    #expect(interval.duration == .infinity)
  }

  @Test func givenUpperBoundNotReached_whenGettingNext_thenReturnsCorrect() async throws {
    withDependencies { $0.calendar = cal } operation: {
      #expect(
        Interval.day(date).next(in: Interval.day(cal.date(byAdding: .day, value: 2, to: date)!))
        == Interval.day(cal.date(byAdding: .day, value: 1, to: date)!)
      )
    }
  }

  @Test func givenUpperBoundReached_whenGettingNext_thenReturnsNil() async throws {
    withDependencies { $0.calendar = cal } operation: {
      #expect(Interval.day(date).next(in: Interval.day(date)) == nil)
    }
  }

  @Test func givenLowerBoundNotReached_whenGettingPrevious_thenReturnsCorrect() async throws {
    withDependencies { $0.calendar = cal } operation: {
      #expect(
        Interval.day(date).previous(in: Interval.day(cal.date(byAdding: .day, value: -2, to: date)!))
        == Interval.day(cal.date(byAdding: .day, value: -1, to: date)!)
      )
    }
  }

  @Test func givenLowerBoundReached_whenGettingPrevious_thenReturnsNil() async throws {
    withDependencies { $0.calendar = cal } operation: {
      #expect(Interval.day(date).previous(in: Interval.day(date)) == nil)
    }
  }

  @Test(.serialized, arguments: Interval.allCases.filter(\.isCountable))
  func givenIsCountable_whenCounting_thenReturnsCorrect(interval: Interval) async throws {
    withDependencies { $0.calendar = cal } operation: {
      for subdivision in Subdivision.allCases where Subdivision(interval).flatMap({ subdivision < $0 }) ?? false {
        #expect(interval.count(by: subdivision) == expected(interval, subdivision))
      }
    }

    func expected(_ interval: Interval, _ subdivision: Subdivision) -> Int {
      switch (interval, subdivision) {
      case _ where Subdivision(interval) == subdivision: return 1
      case (.week, .day): return 6
      case (.month, .day): return 30
      case (.month, .week): return 4
      case (.year, .day): return 364
      case (.year, .week): return 52
      case (.year, .month): return 11
      case (.fromTo, .day): return 11
      case (.fromTo, .week): return 1
      default: Issue.record("Invalid combination \(interval) \(subdivision)")
      }

      return 0
    }
  }

  @Test(arguments: Interval.allCases.filter(\.isUncountable), Subdivision.allCases)
  func givenIsUncountable_whenCounting_thenReturnsMax(interval: Interval, subdivision: Subdivision) async throws {
    withDependencies { $0.calendar = cal } operation: {
      #expect(interval.count(by: subdivision) == .max)
    }
  }

  @Test(arguments: Interval.allCases.filter(\.isCountable))
  func givenIsCountable_whenEnumerating_thenReturnsSome(interval: Interval) async throws {
    withDependencies { $0.calendar = cal } operation: {
      for subdivision in Subdivision.allCases where Subdivision(interval).flatMap({ subdivision < $0 }) ?? true {
        #expect(interval.enumerate(by: subdivision) != nil)
      }
    }
  }

  @Test(arguments: Interval.allCases.filter(\.isUncountable), Subdivision.allCases)
  func givenIsUncountable_whenEnumerating_thenReturnsNil(interval: Interval, subdivision: Subdivision) async throws {
    withDependencies { $0.calendar = cal } operation: {
      #expect(interval.enumerate(by: subdivision) == nil)
    }
  }

  @Test(arguments: Interval.allCases.filter(\.isCountable))
  func givenContainsDate_whenContains_thenReturnsTrue(interval: Interval) async throws {
    withDependencies { $0.calendar = cal } operation: {
      #expect(interval.contains(date))
    }
  }

  @Test(arguments: Interval.allCases.filter(\.hasStart))
  func givenDoesNotContainDate_whenContains_thenReturnsFalse(interval: Interval) async throws {
    withDependencies { $0.calendar = cal } operation: {
      #expect(!interval.contains(.distantPast))
    }
  }

  @Test(arguments: Interval.allCases)
  func givenContainsInterval_whenContains_thenReturnsTrue(interval: Interval) async throws {
    withDependencies { $0.calendar = cal } operation: {
      #expect(interval.contains(.fromTo(.init(start: date, duration: 0))))
    }
  }

  @Test(arguments: Interval.allCases.filter(\.hasEnd))
  func givenDoesNotContainInterval_whenContains_thenReturnsFalse(interval: Interval) async throws {
    withDependencies { $0.calendar = cal } operation: {
      #expect(!interval.contains(.distantFuture))
    }
  }
}
