import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class MainReducerTests: XCTestCase {
  func testAddingAndRemoving() async {
    let subdivision = Calendar.Component.day,
        interval = DateInterval(start: .now, duration: 1)
    
    let store = TestStore(initialState: .init([interval.start]), reducer: MainReducer()) {
      $0.calendar = .current
      $0.date = .constant(.now)
    }
    
    await store.send(.calculateAverage(interval, subdivision))
    await store.receive(/MainReducer.Action.calculateAmount(interval)) { $0.amounts = [interval: 1] }
    await store.receive(/MainReducer.Action._continueCalculatingAverage) { $0.averages = [subdivision: [interval: 1]] }
    
    // TODO: add test for updating subdivisions
//    await store.send(.calculateSubdivision(interval, subdivision))
//    await store.receive(/MainReducer.Action.calculateAmount(interval)) { $0.amounts = [interval: 1] }
//    await store.receive(/MainReducer.Action._continueCalculatingSubdivision) {
//      $0.subdivisions = [subdivision: [interval: [interval: 1]]]
//    }
    
    await store.send(.remove(interval.start)) {
      $0.entries = []
      $0.amounts[interval] = 0
      $0.averages[subdivision]?[interval] = 0
//      $0.subdivisions[subdivision]?[interval]?[interval] = 0
    }
    await store.send(.add(interval.start)) {
      $0.entries.append(interval.start)
      $0.amounts[interval] = 1
      $0.averages[subdivision]?[interval] = 1
//      $0.subdivisions[subdivision]?[interval]?[interval] = 1
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
    let interval = DateInterval(start: .now, duration: 86400 * 10)
    
    let store = TestStore(initialState: .init([interval.start]), reducer: MainReducer())

    await store.send(.calculateAmount(interval)) { $0.amounts = [interval: 1] }
  }

  func testCalculatingAverage() async {
    let amount = 10,
        length = 5,
        subdivision = Calendar.Component.day,
        interval = DateInterval(start: .now, duration: Double(length * 86400))

    let store = TestStore(
      initialState: .init([Date](repeating: interval.start, count: amount)), reducer: MainReducer()
    ) {
      $0.calendar = .current
    }

    await store.send(.calculateAverageUntil(interval.end, subdivision))
    await store.receive(/MainReducer.Action.calculateAverage)
    await store.receive(/MainReducer.Action.calculateAmount) { $0.amounts = [interval: amount] }
    await store.receive(/MainReducer.Action._continueCalculatingAverage) {
      $0.averages = [subdivision: [interval: Double(amount / length)]]
    }
  }
  
  func testCalculatingSubdivision() async {
    let subdivision = Calendar.Component.day,
        interval = DateInterval(start: .now, duration: 2 * 86400),
        startInterval = DateInterval(start: interval.start, duration: 86400),
        endInterval = DateInterval(start: interval.start + 86400, duration: 86400)
    
    let store = TestStore(initialState: .init([interval.start, interval.end - 1]), reducer: MainReducer()) {
      $0.calendar = .current
    }
    
    await store.send(.calculateSubdivision(interval, subdivision))
    await store.receive(/MainReducer.Action.calculateAmount) { $0.amounts = [startInterval: 1] }
    await store.receive(/MainReducer.Action.calculateAmount) { $0.amounts = [startInterval: 1, endInterval: 1] }
    await store.receive(/MainReducer.Action._continueCalculatingSubdivision) {
      $0.subdivisions = [subdivision: [ interval: [startInterval: 1, endInterval: 1]]]
    }
  }
}
