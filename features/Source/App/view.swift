// Created by Leopold Lemmermann on 02.02.25.

import ComposableArchitecture
import Dashboard
import Fact
import History
import Info
import Statistic
import SwiftUIComponents
import Transfer

@ViewAction(for: Smokes.self)
public struct SmokesView: View {
  @Bindable public var store: StoreOf<Smokes>

  public var body: some View {
    TabView(selection: $store.tab) {
      Tab(.localizable(.history), systemImage: "calendar", value: 0) {
        HistoryView(store: store.scope(state: \.history, action: \.history))
          .padding(.bottom, 50)
      }

      Tab(.localizable(.dashboard), systemImage: "square", value: 1) {
        DashboardView(store: store.scope(state: \.dashboard, action: \.dashboard)) {
          send(.transferButtonTapped)
        }
        .padding(.bottom, 50)
        .sheet(item: $store.scope(state: \.transfer, action: \.transfer)) { TransferView(store: $0) }
      }

      Tab(.localizable(.statistic), systemImage: "percent", value: 2) {
        StatisticView(store: store.scope(state: \.statistic, action: \.statistic))
          .padding(.bottom, 50)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .always))
    .indexViewStyle(.page(backgroundDisplayMode: .always))
    .padding(5)
    .overlay(alignment: .bottomLeading) {
      FloatingButton(.init(localizable: .info), systemImage: "info") { send(.infoButtonTapped) }
        .sheet(item: $store.scope(state: \.info, action: \.info)) { InfoView(store: $0) }
        .padding()
    }
    .overlay(alignment: .bottomTrailing) {
      FloatingButton(.init(localizable: .fact), systemImage: "lightbulb") { send(.factButtonTapped) }
        .fullScreenCover(item: $store.scope(state: \.fact, action: \.fact)) {
          FactView(store: $0)
            .padding()
            .presentationBackground(.ultraThinMaterial)
        }
        .padding()
        .popoverTip(FactTip())
    }
    .background {
      Image(.noSmoking).resizable().scaledToFit()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.background), ignoresSafeAreaEdges: .all)
    }
  }

  public init(store: StoreOf<Smokes> = Store(initialState: Smokes.State(), reducer: Smokes.init)) {
    self.store = store
  }
}

#Preview {
  SmokesView()
}
