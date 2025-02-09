// Created by Leopold Lemmermann on 01.04.23.

import Charts
import Components
import ComposableArchitecture
import Extensions
import Format
import SwiftUI
import enum Generated.L10n

public struct HistoryView: View {
  @ComposableArchitecture.Bindable public var store: StoreOf<History>

  public var body: some View {
    Grid {
      Widget {
        AmountsChart(store.plotDataFormatted, description: Text(store.option.description))
      }

      GridRow {
        ConfigurableWidget(selection: $store.option) { option in
          DescriptedValueContent(store.optionAmountFormatted, description: option.description)
        }

        Widget {
          DescriptedValueContent(store.untilHereAmountFormatted, description: L10n.Amount.Until.here)
        }
      }

      Widget {
        HStack {
          DescriptedValueContent(store.dayAmountFormatted, description: L10n.Amount.day)
            .overlay(alignment: .topTrailing) {
              if !store.editing {
                Button { store.editing = true } label: {
                  Label(L10n.Action.modify, systemImage: "square.and.pencil")
                    .font(.title2)
                    .accessibilityIdentifier("start-modifying-button")
                }
              }
            }

          if store.editing {
            IncrementMenu(decrementDisabled: store.dayAmount < 1) {
              store.send(.addButtonTapped)
            } remove: {
              store.send(.removeButtonTapped)
            }
            .transition(.move(edge: .trailing))
            .overlay(alignment: .topTrailing) {
              Button { store.editing = false } label: {
                Label(L10n.Action.dismiss, systemImage: "xmark.circle")
                  .font(.title2)
                  .accessibilityIdentifier("stop-modifying-button")
              }
            }
          }
        }
      }
      .labelStyle(.iconOnly)

      Widget {
        DayPicker(selection: $store.selection, bounds: store.bounds)
          .labelStyle(.iconOnly)
          .buttonStyle(.borderedProminent)
      }
      .gridCellColumns(2)
    }
  }

  public init(store: StoreOf<History>) { self.store = store }
}

fileprivate extension History.State {
  var dayAmountFormatted: Text {
    @Dependency(\.format.amount) var amount
    return amount(dayAmount)
  }

  var untilHereAmountFormatted: Text? {
    @Dependency(\.format) var format
    return format.amount(untilHereAmount)
  }

  var optionAmountFormatted: Text {
    @Dependency(\.format.amount) var amount
    return amount(optionAmount)
  }

  var plotDataFormatted: [(String, Int)]? {
    @Dependency(\.format.plotInterval) var plotInterval
    return plotData?
      .sorted { $0.key < $1.key }
      .map { (plotInterval($0, interval, subdivision) ?? "", $1) }
  }
}

#Preview {
  HistoryView(store: Store(initialState: History.State(), reducer: History.init))
}
