import ComposableArchitecture
import SwiftUI
import LeosMisc

struct MainView: View {
  var body: some View {
    TabView(selection: $selectedTab)
      .overlay(alignment: vSize == .regular ? .bottomLeading : .topTrailing, content: showInfoButton)
      .overlay(alignment: vSize == .regular ? .bottomTrailing : .bottomTrailing, content: showFactButton)
      .sheet(isPresented: Binding { selection == .info } set: { _ in selection = .tab }) { InfoView() }
      .padding()
      .opacity(selection == .fact ? 0 : 1)
      .overlay {
        if selection == .fact {
          FactView(isPresented: Binding { selection == .fact } set: { _ in selection = .tab })
            .transition(.move(edge: vSize == .regular ? .top : .leading))
            .padding()
        }
      }
      .background { Background() }
      .animation(.default, value: selection)
      .animation(.default, value: selectedTab)
      .animation(.easeInOut(duration: 0.5), value: selection == .fact)
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
      .shadow(color: .primary, radius: 5)
  }

  @ViewBuilder private func showFactButton() -> some View {
    Button { selection = .fact } label: { Label("FACT", systemImage: "lightbulb") }
      .labelStyle(.iconOnly)
      .buttonStyle(.borderedProminent)
      .shadow(color: .primary, radius: 5)
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
