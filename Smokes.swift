// Created by Leopold Lemmermann on 28.04.23.

import App
import SwiftUI
import TipKit

@main
struct Main: App {
  var body: some Scene {
    WindowGroup {
      SmokesView()
    }
  }

  init() {
    do {
      if CommandLine.arguments.contains("UI_TESTS") {
        #if DEBUG
        try FileManager.default.removeItem(at: .documentsDirectory.appending(path: "entries.json"))
        try FileManager.default.removeItem(at: .documentsDirectory.appending(path: "stats_selection"))
        UserDefaults.resetStandardUserDefaults()
        #endif
      } else {
        try Tips.configure([
          .displayFrequency(.hourly)
        ])
      }
    } catch { print(error.localizedDescription) }
  }
}
