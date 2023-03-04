import ComposableArchitecture
import SwiftUI

@main
struct Main: App {
  private let store = Store(initialState: .init(), reducer: MainReducer() )
  @Environment(\.scenePhase) private var scene
  
  var body: some Scene {
    WindowGroup {
      if !_XCTIsTesting {
        WithViewStore(store) { viewStore in
          MainView()
            .onAppear { viewStore.send(.loadEntries) }
            .onChange(of: scene) { newScene in
              if newScene != .active { viewStore.send(.saveEntries) }
            }
            .environmentObject(store)
        }
      }
    }
  }
}

extension Store: ObservableObject {}
