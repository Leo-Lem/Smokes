import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class MainReducerTests: XCTestCase {
  func testAddingAndRemoving() async {
    let interval = DateInterval(start: .now, duration: 1)
    
    let store = TestStore(initialState: .init([interval.start]), reducer: MainReducer()) {
      $0.calendar = .current
      $0.date = .constant(.now)
    }
    
    await store.send(.calculateAmount(interval)) { $0.amounts[interval] = 1 }
    await store.send(.remove(interval.start)) {
      $0.entries = []
      $0.amounts[interval] = 0
    }
    await store.send(.add(interval.start)) {
      $0.entries.append(interval.start)
      $0.amounts[interval] = 1
    }
  }
  
  func testSavingAndLoading() async {
    let date = Date.now
    let store = TestStore(initialState: .init([date]), reducer: MainReducer())
    
    await store.send(.saveEntries)
    await store.send(.remove(date)) { $0.entries = [] }
    await store.send(.loadEntries) { $0.entries = [date] }
  }

  func testCalculatingAmount() async {
    let interval = DateInterval(start: .distantPast, duration: 86400 * 10),
        amount = 1000,
        dates = (0..<amount).map { _ in interval.start + Double.random(in: 0..<interval.duration) }
    
    let store = TestStore(initialState: .init(dates), reducer: MainReducer())

    await store.send(.calculateAmount(interval)) { $0.amounts = [interval: amount] }
  }

  func testCalculatingAverage() async {
    let amount = 10, length = 5,
        subdivision = Calendar.Component.day,
        interval = DateInterval(start: .now, duration: Double(length * 86400))

    let store = TestStore(
      initialState: .init([Date](repeating: interval.start, count: amount)), reducer: MainReducer()
    )

    await store.send(.calculateAmountForAverageUntil(interval.end))
    await store.receive(/MainReducer.Action.calculateAmountForAverage)
    await store.receive(/MainReducer.Action.calculateAmount) { $0.amounts = [interval: amount] }
    
    withDependencies { $0.calendar = .current } operation: {
      XCTAssertEqual(store.state.average(interval, by: subdivision), Double(amount / length))
      XCTAssertEqual(store.state.average(until: interval.end, by: subdivision), Double(amount / length))
    }
  }
  
  func testCalculatingSubdivision() async {
    let subdivision = Calendar.Component.day,
        interval = DateInterval(start: Calendar.current.startOfDay(for: .now), duration: 2 * 86400),
        startInterval = DateInterval(start: interval.start, duration: 86400),
        endInterval = DateInterval(start: interval.start + 86400, duration: 86400)
    
    let store = TestStore(initialState: .init([interval.start, interval.end - 1]), reducer: MainReducer()) {
      $0.calendar = .current
    }
    
    await store.send(.calculateAmountForSubdivisionUntil(interval.end, subdivision))
    await store.receive(/MainReducer.Action.calculateAmountForSubdivision)
    await store.receive(/MainReducer.Action.calculateAmount) { $0.amounts = [startInterval: 1] }
    await store.receive(/MainReducer.Action.calculateAmount) { $0.amounts = [startInterval: 1, endInterval: 1] }
    
    withDependencies { $0.calendar = .current } operation: {
      XCTAssertEqual(store.state.subdivide(interval, by: subdivision), [startInterval: 1, endInterval: 1])
    }
  }
}
