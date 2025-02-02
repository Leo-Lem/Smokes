// Created by Leopold Lemmermann on 02.02.25.

import Components
import ComposableArchitecture
import struct ComposableArchitecture.Bindable
import Format

public struct DashboardView: View {
  @Binding var porting: Bool
  @Bindable var store: StoreOf<Dashboard>

  public init(porting: Binding<Bool>, store: StoreOf<Dashboard>) {
    self._porting = porting
    self.store = store
  }

  public var body: some View {
    Grid {
      if size == .regular {
        dayAmountWidget()

        GridRow {
          configurableAmountWidget()
          configurableTimeWidget()
        }

        GridRow {
          untilNowAmountWidget(porterButtonAlignment: .bottomLeading)
          incrementWidget()
        }
      } else {
        GridRow {
          dayAmountWidget().gridCellColumns(2)
          configurableAmountWidget()
        }

        GridRow {
          untilNowAmountWidget(porterButtonAlignment: .bottomLeading)
          configurableTimeWidget()
          incrementWidget()
        }
      }
    }
  }

  @Dependency(\.format) var format
  @Environment(\.verticalSizeClass) var size

  func dayAmountWidget() -> some View {
    Widget {
      DescriptedValueContent(format.amount(store.dayAmount), description: "TODAY")
    }
  }

  func untilNowAmountWidget(porterButtonAlignment: Alignment) -> some View {
    Widget {
      DescriptedValueContent(format.amount(store.untilHereAmount), description: "UNTIL_NOW")
        .overlay(alignment: porterButtonAlignment) {
          Button { porting = true } label: { Label("OPEN_PORTER", systemImage: "folder") }
            .labelStyle(.iconOnly)
            .accessibilityIdentifier("show-porter-button")
        }
    }
  }

  func configurableAmountWidget() -> some View {
    ConfigurableWidget(selection: $store.amountOption.sending(\.changeAmountOption)) { option in
      DescriptedValueContent(format.amount(store.optionAmount), description: option.description)
    }
  }

  func configurableTimeWidget() -> some View {
    ConfigurableWidget(selection: $store.timeOption.sending(\.changeTimeOption)) { option in
      DescriptedValueContent(format.time(store.optionTime), description: option.description)
    }
  }

  func incrementWidget() -> some View {
    Widget {
      IncrementMenu(decrementDisabled: store.dayAmount ?? 0 <= 0) {
        store.send(.add)
      } remove: {
        store.send(.remove)
      }
    }
  }
}

#Preview {
  DashboardView(porting: .constant(false), store: Store(initialState: Dashboard.State(), reducer: Dashboard.init))
}
