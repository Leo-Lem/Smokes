@_exported import SmokesLibrary
@_exported import SmokesModels
@_exported import struct SmokesReducers.App
@_exported import SmokesDependencies

@_exported import struct Foundation.Date
@_exported import typealias Foundation.TimeInterval
@_exported import struct Foundation.URL
@_exported import struct Foundation.Data

import ComposableArchitecture
import SwiftUI

@main
struct Main: SwiftUI.App {
  private let store = Store(initialState: .init(), reducer: App())
  
  var body: some Scene {
    WindowGroup {
      if !_XCTIsTesting {
        WithViewStore(store) { vs in
          MainView()
            .environmentObject(store)
            .onAppear { vs.send(.loadEntries) }
            .onChange(of: scene) { if $0 != .active { vs.send(.saveEntries) } }

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
