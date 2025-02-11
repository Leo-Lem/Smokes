// Created by Leopold Lemmermann on 02.02.25.

import Components
import ComposableArchitecture
import Dashboard
import Fact
import History
import Info
import Statistic
import Transfer

public struct SmokesView: View {
  @Bindable public var store: StoreOf<Smokes>

  public var body: some View {
    TabView(selection: $store.tab) {
      Tab("History", systemImage: "calendar", value: 0) {
        HistoryView(store: store.scope(state: \.history, action: \.history))
          .padding(.bottom, 50)
      }

      Tab("Dashboard", systemImage: "square", value: 1) {
        DashboardView(store: store.scope(state: \.dashboard, action: \.dashboard))
          .padding(.bottom, 50)
          .sheet(item: $store.scope(state: \.transfer, action: \.transfer)) { TransferView(store: $0) }
      }

      Tab("Statistic", systemImage: "percent", value: 2) {
        StatisticView(store: store.scope(state: \.statistic, action: \.statistic))
          .padding(.bottom, 50)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .always))
    .indexViewStyle(.page(backgroundDisplayMode: .always))
    .overlay(alignment: .bottomLeading) {
      FloatingButton("Info", systemImage: "info") { store.send(.infoButtonTapped) }
        .sheet(item: $store.scope(state: \.info, action: \.info)) { InfoView(store: $0) }
        .padding()
    }
    .overlay(alignment: .bottomTrailing) {
      FloatingButton("Fact", systemImage: "lightbulb") { store.send(.factButtonTapped) }
        .fullScreenCover(item: $store.scope(state: \.fact, action: \.fact)) {
          FactView(store: $0)
            .padding()
            .presentationBackground(.ultraThinMaterial)
        }
        .padding()
        .popoverTip(FactTip())
    }
    .padding(5)
    .background { Background() }
  }

  public init(store: StoreOf<Smokes> = Store(initialState: Smokes.State(), reducer: Smokes.init)) {
    self.store = store
  }
}

#Preview {
  SmokesView()
}
