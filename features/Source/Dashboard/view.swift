// Created by Leopold Lemmermann on 02.02.25.

import Components
import ComposableArchitecture
import Format

public struct DashboardView: View {
  @Bindable public var store: StoreOf<Dashboard>

  public var body: some View {
    Grid {
      Widget {
        DescriptedValueContent(store.dayAmountFormatted, description: String(localized: "today"))
      }

      GridRow {
        ConfigurableWidget(selection: $store.amountOption) { option in
          DescriptedValueContent(store.optionAmountFormatted, description: option.description)
        }
        .popoverTip(OptionTip())

        ConfigurableWidget(selection: $store.timeOption) { option in
          DescriptedValueContent(store.optionTimeFormatted, description: option.description)
        }
      }

      GridRow {
        Widget {
          DescriptedValueContent(store.untilHereAmountFormatted, description: String(localized: "until now"))
            .overlay(alignment: .bottomLeading) {
              Button { store.transferring = true } label: { Label("open exporter", systemImage: "folder") }
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
    .animation(.default, values: store.optionAmount)
    .animation(.default, values: store.optionTime)
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
  DashboardView(store: Store(initialState: Dashboard.State(), reducer: Dashboard.init))
    .padding()
}
