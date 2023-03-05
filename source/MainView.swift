import ComposableArchitecture
import SwiftUI

// TODO: enable swipe to change tab, animate tab change with slide
// TODO: build custom tab bar with side option for landscape layout
struct MainView: View {
  var body: some View {
    TabView(selection: $selectedTab) {
      Group {
        HistoryView()
          .tabItem { Label("history", systemImage: "calendar") }
          .tag(0)
        
        DashboardView()
          .tabItem { Image(systemName: "square.split.2x2.fill") }
          .tag(1)
        
        StatsView()
          .tabItem { Label("stats", systemImage: "percent") }
          .tag(2)
      }
      .toolbarBackground(.hidden, for: .tabBar)
      .background {
        Image("smokingarea")
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
