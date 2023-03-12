import ComposableArchitecture
import SwiftUI

struct MainView: View {
  var body: some View {
    TabView(selection: $selectedTab) {
      Group {
        HistoryView()
          .tabItem {
            Label("HISTORY", systemImage: "calendar")
              .accessibilityIdentifier("history-tab-button")
          }
          .tag(0)

        DashboardView()
          .tabItem {
            Label("DASHBOARD", systemImage: "square.split.2x2.fill")
              .accessibilityIdentifier("dashboard-tab-button")
          }
          .tag(1)

        StatsView()
          .tabItem {
            Label("STATS", systemImage: "percent")
              .accessibilityIdentifier("stats-tab-button")
          }
          .tag(2)
      }
      .padding(10)
      .toolbarBackground(.hidden, for: .tabBar)
      .background {
        Image(decorative: "smokingarea")
          .resizable()
          .ignoresSafeArea()
          .scaledToFill()
      }
    }
  }

  @State private var selectedTab = 1
}

// MARK: - (PREVIEWS)

#if DEBUG
struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
      .environmentObject(Store(initialState: .preview, reducer: MainReducer()))
  }
}
#endif
