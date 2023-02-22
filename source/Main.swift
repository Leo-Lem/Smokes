import ComposableArchitecture
import SwiftUI

@main
struct Main: App {
  private let store: StoreOf<MainReducer>
  
  var body: some Scene {
    WindowGroup {
      MainView(store: store)
    }
  }
  
  init() {
    store = .init(initialState: .init(), reducer: MainReducer())
  }
}
