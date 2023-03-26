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
          if progress >= 0.99 {
            MainView()
              .onChange(of: scene) { if $0 != .active { viewStore.send(.entries(.save)) } }
              .environmentObject(store)
              .overlay(alignment: .top) {
#if DEBUG
                Button("Reset") { viewStore.send(.entries(.set([]))) }
                  .buttonStyle(.borderedProminent)
#endif
              }
              .preferredColorScheme(.dark)
          } else {
            LoadingPage(progress: $progress)
              .onAppear {
                @Dependency(\.date.now) var now: Date
                @Dependency(\.calendar) var cal: Calendar
                
                viewStore.send(.entries(.load))
                viewStore.send(.calculateAmountUntil(cal.endOfDay(for: now)))
                viewStore.send(.calculateAmountsUntil(cal.endOfDay(for: now), subdivision: .weekOfYear))
              }
              .task {
                let seconds = 3
                
                for _ in 0 ..< 99 where progress < 1 {
                  progress += 0.01
                  try? await Task.sleep(for: .milliseconds(seconds * 10))
                }
              }
          }
        }
      }
    }
  }

  @State private var progress = 0.0
}

extension Store: ObservableObject {}
