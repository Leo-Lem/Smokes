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
      try Tips.configure([
        .displayFrequency(.hourly)
      ])
    } catch { print(error.localizedDescription) }
  }
}

#Preview {
  SmokesView()
}

// TODO: move localizations to packages
