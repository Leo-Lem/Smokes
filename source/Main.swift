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
          if loadingProgress >= 0.99 {
            MainView()
              .onChange(of: scene) { if $0 != .active { viewStore.send(.saveEntries) } }
              .environmentObject(store)
              .overlay(alignment: .top) {
#if DEBUG
                Button("Reset") { viewStore.send(.setEntries([])) }
                  .buttonStyle(.borderedProminent)
#endif
              }
              .preferredColorScheme(.dark)
          } else {
            LoadingPage(progress: $loadingProgress)
              .onAppear {
                @Dependency(\.date.now) var now: Date
                @Dependency(\.calendar) var cal: Calendar
                
                viewStore.send(.loadEntries)
                viewStore.send(.calculateAmountUntil(cal.endOfDay(for: now)))
                viewStore.send(.calculateAmountsUntil(cal.endOfDay(for: now), .weekOfYear))
              }
              .task {
                let seconds = 3
                
                for _ in 0 ..< 99 where loadingProgress < 1 {
                  loadingProgress += 0.01
                  try? await Task.sleep(for: .milliseconds(seconds * 10))
                }
              }
          }
        }
      }
    }
  }

  @State private var loadingProgress = 0.0
}

extension Store: ObservableObject {}
