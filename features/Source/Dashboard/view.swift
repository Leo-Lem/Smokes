// Created by Leopold Lemmermann on 02.02.25.

import Components
import ComposableArchitecture
import Format
import Generated

public struct DashboardView: View {
  @ComposableArchitecture.Bindable public var store: StoreOf<Dashboard>

  public var body: some View {
    Grid {
      Widget {
        DescriptedValueContent(store.dayAmountFormatted, description: L10n.Amount.today)
      }

      GridRow {
        ConfigurableWidget(selection: $store.amountOption) { option in
          DescriptedValueContent(store.optionAmountFormatted, description: option.description)
        }

        ConfigurableWidget(selection: $store.timeOption) { option in
          DescriptedValueContent(store.optionTimeFormatted, description: option.description)
        }
      }

      GridRow {
        Widget {
          DescriptedValueContent(store.untilHereAmountFormatted, description: L10n.Amount.Until.now)
            .overlay(alignment: .bottomLeading) {
              Button { store.transferring = true } label: { Label(L10n.Transfer.open, systemImage: "folder") }
                .labelStyle(.iconOnly)
                .accessibilityIdentifier("show-porter-button")
            }
        }

        Widget {
          IncrementMenu(decrementDisabled: store.dayAmount <= 0) {
            store.send(.addButtonTapped)
          } remove: {
            store.send(.removeButtonTapped)
          }
        }
      }
    }
  }

  public init(store: StoreOf<Dashboard>) { self.store = store }
}

fileprivate extension Dashboard.State {
  var dayAmountFormatted: Text {
    @Dependency(\.format.amount) var amount
    return amount(dayAmount)
  }

  var optionAmountFormatted: Text {
    @Dependency(\.format.amount) var amount
    return amount(optionAmount)
  }

  var optionTimeFormatted: Text {
    @Dependency(\.format.time) var time
    return time(optionTime)
  }

  var untilHereAmountFormatted: Text {
    @Dependency(\.format.amount) var amount
    return amount(untilHereAmount)
  }
}

#Preview {
  DashboardView(store: Store(
    initialState: Dashboard.State(transferring: Shared(value: false)),
    reducer: Dashboard.init)
  )
  .padding()
}
