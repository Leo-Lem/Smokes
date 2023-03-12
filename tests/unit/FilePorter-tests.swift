import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class FilePorterTests: XCTestCase {
  func testCreatingFile() async {
    await withDependencies { $0.calendar = .current } operation: {
      let dates = [Date.distantPast, .now, .now, .distantFuture]
      
      let store = TestStore(initialState: .init(), reducer: FilePorter())
      
      await store.send(.createFile(dates)) { $0.file = SmokesFile(dates.subdivide(by: .day)) }
    }
  }
}
