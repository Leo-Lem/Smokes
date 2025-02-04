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
  @ComposableArchitecture.Bindable
  var store: StoreOf<Smokes> = Store(initialState: Smokes.State(), reducer: Smokes.init)

  public var body: some View {
    if #available(iOS 18.0, *) {
      TabView(selection: $store.tab.sending(\.selectTab)) {
        Tab("HISTORY", systemImage: "calendar", value: Smokes.State.Tab.history) {
          HistoryView(store: store.scope(state: \.history, action: \.history))
            .padding(.bottom, 50)
        }

        Tab("DASHBOARD", systemImage: "square", value: Smokes.State.Tab.dashboard) {
          DashboardView(store: store.scope(state: \.dashboard, action: \.dashboard))
            .padding(.bottom, 50)
            .sheet(item: $store.scope(state: \.transfer, action: \.transfer)) { TransferView(store: $0) }
        }

        Tab("STATS", systemImage: "percent", value: Smokes.State.Tab.statistic) {
          StatisticView(store: store.scope(state: \.statistic, action: \.statistic))
            .padding(.bottom, 50)
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .always))
      .indexViewStyle(.page(backgroundDisplayMode: .always))
      .overlay(alignment: .bottomLeading) {
        FloatingButton("INFO", systemImage: "info") { store.send(.infoButtonTapped) }
          .sheet(isPresented: $store.info.sending(\.info)) { InfoView() }
          .padding()
      }
      .overlay(alignment: .bottomTrailing) {
        FloatingButton("FACT", systemImage: "lightbulb") { store.send(.factButtonTapped) }
          .fullScreenCover(item: $store.scope(state: \.fact, action: \.fact)) { FactView(store: $0) }
          .padding()
      }
      .padding(5)
      .background { Background() }
    } else {
      // TODO: update the custom tab view:
      // https://stackoverflow.com/questions/75320164/swiftui-custom-tabview-with-paging-style
    }
  }

  public init() {}
}

#Preview {
  SmokesView()
}
