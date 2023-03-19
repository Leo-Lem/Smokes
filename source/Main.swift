import ComposableArchitecture
import SwiftUI

@main
struct Main: App {
  private let store = Store(initialState: .init(), reducer: MainReducer())
  @Environment(\.scenePhase) private var scene

  var body: some Scene {
    WindowGroup {
      if !_XCTIsTesting {
        WithViewStore(store) { viewStore in
          MainView()
            .onAppear { viewStore.send(.loadEntries) }
            .onChange(of: scene) { if $0 != .active { viewStore.send(.saveEntries) } }
            .environmentObject(store)
            .overlay(alignment: .top) {
              #if DEBUG
              Button("Reset") { viewStore.send(.setEntries([]))}
                .buttonStyle(.borderedProminent)
              #endif
            }
            .preferredColorScheme(.dark)
        }
      }
    }
  }
}

extension Store: ObservableObject {}
