// Created by Leopold Lemmermann on 02.02.25.

import Components
import ComposableArchitecture
import Extensions
import Format

public struct DashboardView: View {
  @Bindable public var store: StoreOf<Dashboard>

  public var body: some View {
    Grid {
      Widget {
        LoadableWithDescription("\(store.dayAmount) smokes", description: "today")
      }

      GridRow {
        ConfigurableWidget(selection: $store.amountOption) { option in
          LoadableWithDescription("\(store.optionAmount) smokes", description: option.description)
        }
        .popoverTip(OptionTip())

        ConfigurableWidget(selection: $store.timeOption) { option in
          LoadableWithDescription("\(store.optionTime, format: .timeInterval)", description: option.description)
        }
      }

      GridRow {
        Widget {
          LoadableWithDescription("\(store.untilHereAmount) smokes", description: "until now")
            .overlay(alignment: .bottomLeading) {
              Button("open exporter", systemImage: "folder") { store.transferring = true }
                .labelStyle(.iconOnly)
                .accessibilityIdentifier("show-porter-button")
                .popoverTip(TransferTip())
            }
        }

        Widget {
          IncrementMenu(decrementDisabled: store.dayAmount <= 0) {
            store.send(.addButtonTapped, animation: .default)
          } remove: {
            store.send(.removeButtonTapped, animation: .default)
          }
        }
      }
    }
    .animation(.default, values: CombineHashable(store.optionAmount, store.optionTime))
    .onAppear { store.send(.reload) }
  }

  public init(store: StoreOf<Dashboard>) { self.store = store }
}

#Preview {
  DashboardView(store: Store(initialState: Dashboard.State(), reducer: Dashboard.init))
    .padding()
}
