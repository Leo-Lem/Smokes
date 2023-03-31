import ComposableArchitecture
import SwiftUI

struct MainView: View {
  var body: some View {
    TabView(selection: $selectedTab)
      .padding(10)
      .background { Background() }
  }

  @State private var selectedTab = MainTab.dashboard
}

enum MainTab: String, Tabbable {
  case history = "HISTORY", dashboard = "DASHBOARD", stats = "STATS"

  var tab: some View {
    GeometryReader { _ in
      switch self {
      case .history: HistoryView()
      case .dashboard: DashboardView()
      case .stats: StatsView()
      }
    }
  }
  
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
  
  private var title: LocalizedStringKey { LocalizedStringKey(rawValue) }
  
  private var icon: String {
    switch self {
    case .history: return "calendar"
    case .dashboard: return "square"
    case .stats: return "percent"
    }
  }
  
  private var a11yID: String {
    switch self {
    case .history: return "history-tab-button"
    case .dashboard: return "dashboard-tab-button"
    case .stats: return "stats-tab-button"
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
      .environmentObject(Store(initialState: .init(), reducer: MainReducer()))
  }
}
#endif
