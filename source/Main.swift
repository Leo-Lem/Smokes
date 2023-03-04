import ComposableArchitecture
import SwiftUI

@main
struct Main: App {
  private let store: StoreOf<MainReducer>
  @Environment(\.scenePhase) private var scene
  
  var body: some Scene {
    WindowGroup {
      MainView()
        .environmentObject(store)
        .onChange(of: scene) { newScene in
          // TODO: move the persistance into a separate reducer
          if newScene != .active {
            try? Dependency(\.persistor).wrappedValue.write(viewStore.state.entries.dates, to: "entries")
          }
        }
    }
  }
  
  private var viewStore: ViewStoreOf<MainReducer>
  
  init() {
    store = .init(
      initialState: .init((try? Dependency(\.persistor).wrappedValue.read(from: "entries")) ?? []),
      reducer: MainReducer()
    )
    
    viewStore = ViewStore(store)
  }
}

extension Store: ObservableObject {}
