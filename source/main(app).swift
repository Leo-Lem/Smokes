import ComposableArchitecture
import SwiftUI

@main
struct Main: App {
  private let store = Store(initialState: .init(), reducer: MainReducer())

  var body: some Scene {
    WindowGroup {
      if !_XCTIsTesting {
        WithViewStore(store) { viewStore in
          if progress >= 0.99 {
            MainView()
              .onChange(of: scene) { if $0 != .active { viewStore.send(.entries(.save)) } }
              .environmentObject(store)
              .preferredColorScheme(.dark)
              .overlay(alignment: .top) {
#if DEBUG
                Button("Reset") { viewStore.send(.entries(.set([]))) }
                  .buttonStyle(.borderedProminent)
#endif
              }
          } else {
            LaunchPage(progress: $progress)
              .labelStyle(.iconOnly)
              .task {
                viewStore.send(.entries(.load))
                
                for _ in 0 ..< 99 where progress < 1 {
                  progress += 0.01
                  try? await Task.sleep(for: .milliseconds(30))
                }
              }
          }
        }
      }
    }
  }

  @State private var progress = 0.0
  @Environment(\.scenePhase) private var scene
}

extension Store: ObservableObject {}
