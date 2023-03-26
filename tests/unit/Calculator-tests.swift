// Created by Leopold Lemmermann on 26.03.23.

@testable import Smokes
import XCTest

@MainActor
final class CalculatorTests: XCTestCase {
//  func testCalculatingAverage() async {
//    let amount = 10, length = 5,
//        subdivision = Calendar.Component.day,
//        interval = DateInterval(start: .now, duration: Double(length * 86400)),
//        dates = [Date](repeating: interval.start, count: amount)
//    
//    let store = TestStore(initialState: .init(), reducer: MainReducer())
//
//    await store.send(.calculateAmountUntil(interval.end))
//    await store.receive(/MainReducer.Action.calculateAmount) { $0.amounts = [interval: amount] }
//    
//    withDependencies { $0.calendar = .current } operation: {
//      XCTAssertEqual(store.state.average(interval, by: subdivision), Double(amount / length))
//      XCTAssertEqual(
//        store.state.average(.init(start: store.state.entries.startDate, end: interval.end), by: subdivision),
//        Double(amount / length)
//      )
//    }
//  }
//  
//  func testCalculatingSubdivision() async {
//    let subdivision = Calendar.Component.day,
//        interval = DateInterval(start: Calendar.current.startOfDay(for: .now), duration: 2 * 86400),
//        startInterval = DateInterval(start: interval.start, duration: 86400),
//        endInterval = DateInterval(start: interval.start + 86400, duration: 86400),
//        start = [interval.start, interval.end - 1]
//    
//    let store = TestStore(initialState: .init(), reducer: MainReducer()) {
//      $0.calendar = .current
//    }
//    
//    await store.send(.calculateAmountsUntil(interval.end, subdivision: subdivision))
//    await store.receive(/MainReducer.Action.calculateAmounts)
//    await store.receive(/MainReducer.Action.calculateAmount) { $0.amounts = [startInterval: 1] }
//    await store.receive(/MainReducer.Action.calculateAmount) { $0.amounts = [startInterval: 1, endInterval: 1] }
//    
//    withDependencies { $0.calendar = .current } operation: {
//      XCTAssertEqual(store.state.subdivide(interval, by: subdivision), [startInterval: 1, endInterval: 1])
//    }
//  }
}
