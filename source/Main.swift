import ComposableArchitecture
import SwiftUI

@main
struct Main: App {
  let store: StoreOf<MainReducer>
  
  var body: some Scene {
    WindowGroup {
      MainView()
        .environmentObject(store)
    }
  }
  
  init() {
    store = .init(
      initialState: .init((try? Dependency(\.persistor).wrappedValue.read(from: "entries")) ?? []),
      reducer: MainReducer()
    )
  }
}

extension Store: ObservableObject {}
