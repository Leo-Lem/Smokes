// Created by Leopold Lemmermann on 02.02.25.

import Components
import ComposableArchitecture
import Format
import Generated

public struct DashboardView: View {
  @ComposableArchitecture.Bindable var store: StoreOf<Dashboard>

  public var body: some View {
    Grid {
      Widget {
        DescriptedValueContent(format.amount(store.dayAmount), description: L10n.Amount.today)
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
          DescriptedValueContent(format.amount(store.untilHereAmount), description: L10n.Amount.Until.now)
            .overlay(alignment: .bottomLeading) {
              Button { store.send(.transfer) } label: { Label(L10n.Transfer.open, systemImage: "folder") }
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
  DashboardView(store: Store(
    initialState: Dashboard.State(transferring: Shared(value: false)),
    reducer: Dashboard.init)
  )
  .padding()
}
