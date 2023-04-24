import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class MainReducerTests: XCTestCase {
  func testReloadingCache() async throws {
    let store = TestStore(initialState: .init(), reducer: MainReducer()) { $0.calendar = .current }
    
    let entries = [Date](), date = Date.now
    
    await store.send(.entries(.set(entries)))
    await store.receive(/.cache(.reload(entries)), timeout: 1)
    
    await store.send(.entries(.add(date))) { $0.entries.entries = [date] }
    await store.receive(/.cache(.reload([date], date: date)), timeout: 1)
    
    await store.send(.entries(.remove(date))) { $0.entries.entries = [] }
    await store.receive(/.cache(.reload([], date: date)), timeout: 1)
  }
  
  func testLoading() async throws {
    let store = TestStore(initialState: .init(), reducer: MainReducer()) {
      $0.calculator.amount = { _, _ in 1 }
    }
    
    await store.send(.load(.alltime))
    await store.receive(/.cache(.load([], interval: .alltime)), timeout: 1) {
      $0.cache.amounts[.alltime] = 1
    }
  }
  
  func testLoadingAll() async throws {
    let date = Date.now
    
    let store = TestStore(initialState: .init(), reducer: MainReducer()) {
      $0.calculator.amount = { _, _ in 1 }
      $0.calendar = .current
    }
    
    store.exhaustivity = .off
      
    await store.send(.loadAll(.week(date), subdivision: .day))
    await store.receive(/.cache(.loadAll([], interval: .week(date), subdivision: .day)), timeout: 1)
  }
  
  func testGettingEntries() async throws {
    withDependencies { $0.calendar = .current } operation: {
      let date = Date(timeIntervalSinceReferenceDate: 0)
      let entries = [.distantPast, date, date + 86401, date + 86400 * 8, date + 86400 * 40, .distantFuture]
      
      let store = TestStore(
        initialState: .init(entries: .init(entries: entries, areLoaded: true)), reducer: MainReducer()
      )
      
      for (interval, expected) in zip(exampleIntervals(for: date), [
        [date], Array(entries[1...2]), Array(entries[1...3]), Array(entries[1...4]),
        Array(entries[1...]), Array(entries[...1]), [date], entries
      ]) {
        XCTAssertEqual(store.state.entries(for: interval), expected)
      }
    }
  }
  
  func testGettingAmount() async throws {
    let intervals = exampleIntervals(for: Date(timeIntervalSinceReferenceDate: 0))
    
    let store = TestStore(initialState: stateWithIntervalsHashCache(intervals), reducer: MainReducer()) {
      $0.calendar = .current
    }
    
    for interval in intervals {
      XCTAssertEqual(store.state.amount(for: interval), interval.hashValue)
    }
  }
  
  func testCalculatingAverage() async throws {
    withDependencies {
      $0.calendar = .current
      $0.date = .constant(.now)
      $0.calculator.average = { _, interval, _ in Double(interval.hashValue)}
    } operation: {
      let intervals = exampleIntervals(for: Date(timeIntervalSinceReferenceDate: 0))
      
      let store = TestStore(initialState: stateWithIntervalsHashCache(intervals), reducer: MainReducer())
      
      for interval in intervals where interval != .alltime {
        for subdivision in Subdivision.allCases {
          XCTAssertEqual(store.state.average(for: interval, by: subdivision), Double(interval.hashValue))
        }
      }
    }
  }
  
  func testCalculatingTrend() async throws {
    withDependencies {
      $0.calendar = .current
      $0.date = .constant(.now)
      $0.calculator.trend = { _, interval, _ in Double(interval.hashValue)}
    } operation: {
      let intervals = exampleIntervals(for: Date(timeIntervalSinceReferenceDate: 0))
      
      let store = TestStore(initialState: stateWithIntervalsHashCache(intervals), reducer: MainReducer())
      
      for interval in intervals where interval != .alltime {
        for subdivision in Subdivision.allCases {
          XCTAssertEqual(store.state.trend(for: interval, by: subdivision), Double(interval.hashValue))
        }
      }
    }
  }
  
  private func stateWithIntervalsHashCache(_ intervals: [Interval]) -> MainReducer.State {
    .init(cache: .init(amounts: .init(uniqueKeysWithValues: intervals.map { ($0, $0.hashValue) })))
  }
  
  private func exampleIntervals(for date: Date) -> [Interval] {
    [
      Interval.day(date), Interval.week(date), Interval.month(date), Interval.year(date),
      Interval.from(date), Interval.to(date), Interval.fromTo(.init(start: date, end: date)), Interval.alltime
    ]
  }
}
