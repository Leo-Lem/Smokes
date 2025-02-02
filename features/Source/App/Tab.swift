// Created by Leopold Lemmermann on 02.02.25.

import SwiftUI

public enum Tab: String, Sendable {
  case history = "HISTORY",
       dashboard = "DASHBOARD",
       stats = "STATS"

  var tabItem: some View {
    VStack {
      Image(systemName: icon)
        .imageScale(.large)

      Text(title)
        .lineLimit(1)
        .minimumScaleFactor(0.5)
    }
    .foregroundColor(.primary)
    .padding()
    .accessibilityIdentifier(a11yID)
  }

  var title: LocalizedStringKey { LocalizedStringKey(rawValue) }

  var icon: String {
    switch self {
    case .history: return "calendar"
    case .dashboard: return "square"
    case .stats: return "percent"
    }
  }

  var a11yID: String {
    switch self {
    case .history: return "history-tab-button"
    case .dashboard: return "dashboard-tab-button"
    case .stats: return "stats-tab-button"
    }
  }
}
