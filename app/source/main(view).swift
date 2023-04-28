import ComposableArchitecture
import SwiftUI

struct MainView: View {
  var body: some View {
    TabView(selection: $selectedTab)
      .overlay(alignment: vSize == .regular ? .bottomLeading : .bottomTrailing, content: showInfoButton)
      .overlay(alignment: vSize == .regular ? .bottomTrailing : .topTrailing, content: showFactButton)
      .if(selection == .fact) { $0.hidden() }
      .sheet(isPresented: Binding { selection == .info } set: { _ in selection = .tab }) { InfoView() }
      .overlay {
        if selection == .fact {
          FactView(isPresented: Binding { selection == .fact } set: { _ in selection = .tab })
            .transition(.move(edge: vSize == .regular ? .top : .leading))
        }
      }
      .padding(10)
      .background { Background() }
      .animation(.default, value: selection)
      .animation(.default, value: selectedTab)
  }

  @State private var selection = Selection.fact
  @State private var selectedTab = MainTab.dashboard

  @Environment(\.verticalSizeClass) private var vSize

  enum Selection { case tab, fact, info }
}

extension MainView {
  @ViewBuilder private func showInfoButton() -> some View {
    Button { selection = .info } label: { Label("INFO", systemImage: "info") }
      .labelStyle(.iconOnly)
      .buttonStyle(.borderedProminent)
  }
  
  @ViewBuilder private func showFactButton() -> some View {
    Button { selection = .fact } label: { Label("FACT", systemImage: "lightbulb") }
      .labelStyle(.iconOnly)
      .buttonStyle(.borderedProminent)
  }
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
      .environmentObject(Store(initialState: .init(), reducer: App()))
  }
}
#endif
