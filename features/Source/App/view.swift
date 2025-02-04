// Created by Leopold Lemmermann on 02.02.25.

import Components
import ComposableArchitecture
import Extensions
import Dashboard
import Fact
import Info

public struct SmokesView: View {
  @ComposableArchitecture.Bindable var store: StoreOf<Smokes>

  public var body: some View {
    TabView(selection: $store.tab.sending(\.selectTab))
      .overlay(alignment: .bottomLeading) {
        FloatingButton("INFO", systemImage: "info") { store.send(.infoButtonTapped) }
          .sheet(isPresented: $store.info.sending(\.info), content: InfoView.init)
      }
      .overlay(alignment: .bottomTrailing) {
        FloatingButton("FACT", systemImage: "lightbulb") { store.send(.factButtonTapped) }
          .fullScreenCover(item: $store.scope(state: \.fact, action: \.fact), content: FactView.init)
      }
      .padding()
//      .overlay {
//        if selection == .fact {
//          FactView(isPresented: Binding { selection == .fact } set: { _ in selection = .tab })
//            .transition(.move(edge: .top))
//            .padding()
//        }
//      }
      .background { Background() }
  }

  public init(store: StoreOf<Smokes>) { self.store = store }
}

extension Tab: Tabbable {
  public static let allCases = [Self.history, .dashboard, .stats]

  public var tab: some View {
    switch self {
//    case .history: HistoryView()
//    case .dashboard: DashboardView()
//    case .stats: StatsView()
    default: EmptyView()
    }
  }
}

#Preview {
  SmokesView(store: Store(initialState: Smokes.State(), reducer: Smokes.init))
}
