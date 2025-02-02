// Created by Leopold Lemmermann on 02.02.25.

import Components
import ComposableArchitecture
import Extensions
import Dashboard

public struct SmokesView: View {
  @Bindable var store = StoreOf<Smokes>()

  public var body: some View {
    TabView(selection: $store.tab)
//      .overlay(alignment: vSize == .regular ? .bottomLeading : .topTrailing, content: showInfoButton)
//      .overlay(alignment: vSize == .regular ? .bottomTrailing : .bottomTrailing, content: showFactButton)
//      .sheet(isPresented: Binding { selection == .info } set: { _ in selection = .tab }) { InfoView() }
      .padding()
      .opacity(selection == .fact ? 0 : 1)
//      .overlay {
//        if selection == .fact {
//          FactView(isPresented: Binding { selection == .fact } set: { _ in selection = .tab })
//            .transition(.move(edge: vSize == .regular ? .top : .leading))
//            .padding()
//        }
//      }
      .background { Background() }
      .animation(.default, value: selection)
      .animation(.default, value: selectedTab)
      .animation(.easeInOut(duration: 0.5), value: selection == .fact)
  }
}

extension Tab: Tabbable {
  static let allCases = [Self.history, .dashboard, .stats]

  var tab: some View {
    switch self {
//    case .history: HistoryView()
//    case .dashboard: DashboardView()
//    case .stats: StatsView()
    default: EmptyView()
    }
  }
}
