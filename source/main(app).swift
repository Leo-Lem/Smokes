import ComposableArchitecture
import SwiftUI

@main
struct Main: App {
  private let store = Store(initialState: .init(), reducer: MainReducer())

  var body: some Scene {
    WindowGroup {
      if !_XCTIsTesting {
        WithViewStore(store) { vs in
          MainView()
            .environmentObject(store)
            .onAppear { vs.send(.entries(.load)) }
            .onChange(of: scene) { if $0 != .active { vs.send(.entries(.save)) } }
          
#if DEBUG
          Button("Reset") { vs.send(.entries(.set([]))) }
            .buttonStyle(.borderedProminent)
#endif
        }
      }
    }
  }

  @Environment(\.scenePhase) private var scene
}

extension Store: ObservableObject {}
