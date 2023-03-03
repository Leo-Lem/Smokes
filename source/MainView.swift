import ComposableArchitecture
import SwiftUI

struct MainView: View {
  var body: some View {
    TabView(selection: $selectedTab) {
      HistoryView()
        .tabItem { Label("History", systemImage: "calendar") }
        .tag(0)

      DashboardView()
        .tabItem { Label("", systemImage: "square") }
        .tag(1)
//      
//      AveragesView(store: store)
//        .tabItem { Label("Averages", systemImage: "percent") }
//        .tag(2)
    }
  }
  
  @State private var selectedTab = 1
}

// MARK: - (PREVIEWS)

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
