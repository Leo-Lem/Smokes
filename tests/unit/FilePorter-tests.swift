import ComposableArchitecture
@testable import Smokes
import XCTest

@MainActor
final class FilePorterTests: XCTestCase {
  func testCreatingFile() async {
    let dates = [Date.distantPast, .now, .distantFuture]
    
    let store = TestStore(initialState: .init(format: .json), reducer: FilePorter())
    
    await store.send(.createFile(dates)) { $0.file = try SmokesFile(dates, format: .json) }
  }
  
  func testSettingFormat() async {
    let dates = [Date.distantPast, .now, .distantFuture]
    
    let store = TestStore(initialState: .init(format: .json), reducer: FilePorter())
    
    await store.send(.setFormat(.utf8PlainText)) { $0.format = .utf8PlainText }
    await store.send(.createFile(dates)) { $0.file = try SmokesFile(dates, format: .utf8PlainText) }
  }
  
  func testReadingFile() async {
    let store = TestStore(initialState: .init(format: .json), reducer: FilePorter())
    
    // TODO: figure this out
  }
}
