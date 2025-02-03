// Created by Leopold Lemmermann on 02.02.25.

import Components
import ComposableArchitecture
import Format

public struct DashboardView: View {
  @ComposableArchitecture.Bindable var store: StoreOf<Dashboard>
  @Binding var porting: Bool

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
              Button { porting = true } label: { Label("OPEN_PORTER", systemImage: "folder") }
                .labelStyle(.iconOnly)
                .accessibilityIdentifier("show-porter-button")
            }
        }

        Widget {
          IncrementMenu(decrementDisabled: store.dayAmount ?? 0 <= 0) {
            store.send(.add)
          } remove: {
            store.send(.remove)
          }
        }
      }
    }
  }

  @Dependency(\.format) var format

  public init(porting: Binding<Bool>, store: StoreOf<Dashboard>) {
    self._porting = porting
    self.store = store
  }
}

#Preview {
  DashboardView(porting: .constant(false), store: Store(initialState: Dashboard.State(), reducer: Dashboard.init))
    .padding()
}
