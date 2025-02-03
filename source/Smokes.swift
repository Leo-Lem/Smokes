import ComposableArchitecture
import SwiftUI
import App

@main
struct Main: SwiftUI.App {
  var body: some Scene {
    WindowGroup {
      if !_XCTIsTesting {
        SmokesView(store: store)
// #if DEBUG
//        if CommandLine.arguments.contains("-wReset") {
//          Button("Reset") { vs.send(.entries(.set([]))) }
//            .buttonStyle(.borderedProminent)
//        }
// #endif
      }
    }
  }

  private let store = Store(initialState: Smokes.State(), reducer: Smokes.init)
}

extension Store: @retroactive ObservableObject {}
