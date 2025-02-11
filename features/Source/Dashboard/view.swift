// Created by Leopold Lemmermann on 02.02.25.

import Components
import ComposableArchitecture
import Extensions

public struct DashboardView: View {
  @Bindable public var store: StoreOf<Dashboard>

  public var body: some View {
    Grid {
      LoadableWithDescription("\(store.dayAmount) smokes", description: "today")
        .widgetStyle()

      GridRow {
        LoadableWithDescription("\(store.optionAmount) smokes", description: "\(store.amountOption.rawValue)")
          .widgetStyle($store.amountOption)
          .popoverTip(OptionTip())

        LoadableWithDescription(
          store.optionTime.isFinite ? "\(store.optionTime, format: .timeInterval)" : "No data",
          description: "\(store.timeOption.rawValue)"
        )
        .widgetStyle($store.timeOption)
      }

      GridRow {
          LoadableWithDescription("\(store.untilHereAmount) smokes", description: "until now")
            .overlay(alignment: .bottomLeading) {
              Button("open exporter", systemImage: "folder") { store.transferring = true }
                .labelStyle(.iconOnly)
                .accessibilityIdentifier("show-porter-button")
                .popoverTip(TransferTip())
            }
            .widgetStyle()

          IncrementMenu(decrementDisabled: store.dayAmount <= 0) {
            store.send(.addButtonTapped, animation: .default)
          } remove: {
            store.send(.removeButtonTapped, animation: .default)
          }
          .widgetStyle()
      }
    }
    .animation(.default, value: .combine(store.optionAmount, store.optionTime))
    .onAppear { store.send(.reload) }
  }

  public init(store: StoreOf<Dashboard>) { self.store = store }
}

#Preview {
  DashboardView(store: Store(initialState: Dashboard.State(), reducer: Dashboard.init))
    .padding()
}
