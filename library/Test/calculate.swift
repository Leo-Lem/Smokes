// Created by Leopold Lemmermann on 28.04.23.

@testable import Calculate
import Dependencies
import Foundation
import Testing

struct CalculateTests {
  let calculate = Calculate.liveValue
  let date = Date(timeIntervalSinceReferenceDate: 0)
  var entries: [Date] { (-10..<10).map { date + TimeInterval($0 * 86400) } }

  @Test func whenFiltering_thenReturnsCorrect() {
    #expect(calculate.filter(.from(date + 2 * 86400), entries).count == 8)
    #expect(calculate.filter(.to(date + 86400), entries).count == 12)
    #expect(calculate.filter(.alltime, []).isEmpty)
  }

  @Test func whenFilteringAmounts_thenReturnsFilteredAmounts() async throws {
    withDependencies { $0.calendar = .current } operation: {
      var amounts = calculate.amounts(.week(date), .day, entries)
      #expect(amounts?.count == 7)
      amounts = calculate.amounts(.alltime, .day, [])
      #expect(amounts == nil)
    }
  }

  @Test func whenAmounting_thenReturnsCorrect() async throws {
    #expect(calculate.amount(.to(date + 2 * 86400), entries) == 13)
    #expect(calculate.amount(.from(date + 3 * 86400), entries) == 7)
    #expect(calculate.amount(.alltime, entries) == 20)
    #expect(calculate.amount(.alltime, []) == 0)
  }

  @Test func whenAveraging_thenReturnsCorrect() async throws {
    withDependencies { $0.calendar = .current } operation: {
      #expect(calculate.average(.week(date), .day, entries)! < 1.1
              && calculate.average(.week(date), .day, entries)! > 0.9)
      #expect(calculate.average(.alltime, .day, entries) == 0)
      #expect(calculate.average(.day(date), .day, entries) == .infinity)
    }
  }

  @Test func whenTrending_thenReturnsCorrect() async throws {
    withDependencies { $0.calendar = .current } operation: {
      #expect(calculate.trend(.week(date), .day, entries)! < 0.1
              && calculate.trend(.week(date), .day, entries)! > -0.1)
      #expect(calculate.trend(.alltime, .day, entries) == nil)
      #expect(calculate.trend(.day(date), .day, entries) == .infinity)
    }
  }

  @Test func whenCalculatingBreak_thenReturnsCorrect() async throws {
    #expect(calculate.break(date + 3.5 * 86400, entries) == 43200)
    #expect(calculate.break(date, []) == .infinity)
  }

  @Test func whenCalculatingLongestBreak_thenReturnsCorrect() async throws {
    #expect(calculate.longestBreak(date + 4 * 86400, entries) == 86400)
    #expect(calculate.longestBreak(date, []) == .infinity)
    #expect(calculate.longestBreak(date + 9999, entries) == 86400)
  }

  @Test func whenAveragingBreak_thenReturnsCorrect() async throws {
    withDependencies { $0.calendar = .current } operation: {
      #expect(calculate.averageBreak(.week(date), entries) < 86399.9
              && calculate.averageBreak(.week(date), entries) > 86399.7)
      #expect(calculate.averageBreak(.day(date), entries) == .infinity)
    }
  }
}
