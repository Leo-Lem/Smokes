// Created by Leopold Lemmermann on 02.02.25.

import Components
import ComposableArchitecture
import Format

public struct DashboardView: View {
  @ComposableArchitecture.Bindable var store: StoreOf<Dashboard>

  public var body: some View {
    Grid {
      Widget {
        DescriptedValueContent(format.amount(store.dayAmount), description: "TODAY")
      }

      GridRow {
        ConfigurableWidget(selection: $store.amountOption.sending(\.changeAmountOption)) { option in
          DescriptedValueContent(format.amount(store.optionAmount), description: option.description)
        }

        ConfigurableWidget(selection: $store.timeOption.sending(\.changeTimeOption)) { option in
          DescriptedValueContent(format.time(store.optionTime), description: option.description)
        }
      }

      GridRow {
        Widget {
          DescriptedValueContent(format.amount(store.untilHereAmount), description: "UNTIL_NOW")
            .overlay(alignment: .bottomLeading) {
              Button { store.send(.transfer) } label: { Label("OPEN_PORTER", systemImage: "folder") }
                .labelStyle(.iconOnly)
                .accessibilityIdentifier("show-porter-button")
            }
        }

        Widget {
          IncrementMenu(decrementDisabled: store.dayAmount <= 0) {
            store.send(.add)
          } remove: {
            store.send(.remove)
          }
        }
      }
    }
  }

  @Dependency(\.format) var format

  public init(store: StoreOf<Dashboard>) { self.store = store }
}

#Preview {
  DashboardView(store: Store(initialState: Dashboard.State(), reducer: Dashboard.init))
    .padding()
}
