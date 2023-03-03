import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class MainReducerTests: XCTestCase {
  func test() async {
    let store = TestStore(initialState: .init([]), reducer: MainReducer())
  }
}
