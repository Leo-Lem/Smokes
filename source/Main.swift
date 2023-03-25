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
          if loadingProgress >= 1 {
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
            VStack {
              Spacer()
              ProgressView(value: loadingProgress)
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background { Background() }
            .onAppear {
              viewStore.send(.loadEntries)

              @Dependency(\.date.now) var now: Date
              @Dependency(\.calendar) var cal: Calendar
              let endOfDay = cal.endOfDay(for: now)
              viewStore.send(.calculateAmountUntil(endOfDay))
              viewStore.send(.calculateAmountsUntil(endOfDay, .weekOfYear))
            }
            .task {
              for _ in 0 ..< 100 {
                loadingProgress += 0.01
                try? await Task.sleep(for: .milliseconds(5))
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
