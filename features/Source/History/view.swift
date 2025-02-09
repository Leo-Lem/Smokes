// Created by Leopold Lemmermann on 01.04.23.

import Charts
import Components
import ComposableArchitecture
import Extensions
import Format
import SwiftUI

@ViewAction(for: History.self)
public struct HistoryView: View {
  @ComposableArchitecture.Bindable public var store: StoreOf<History>

  public var body: some View {
    Grid {
      Widget {
        AmountsChart(
          store.plotData?
            .sorted { $0.key < $1.key }
            .map { (format.plotInterval($0, bounds: store.interval, sub: store.subdivision) ?? "", $1) },
          description: Text(store.option.description)
        )
      }

      GridRow {
        ConfigurableWidget(selection: $store.option) { option in
          DescriptedValueContent(format.amount(store.optionAmount), description: option.description)
        }

        Widget {
          DescriptedValueContent(format.amount(store.untilHereAmount), description: "UNTIL_THIS_DAY")
        }
      }

      Widget {
        HStack {
          DescriptedValueContent(format.amount(store.dayAmount), description: "THIS_DAY")
            .overlay(alignment: .topTrailing) {
              if !store.editing {
                Button { store.editing = true } label: {
                  Label("MODIFY", systemImage: "square.and.pencil")
                    .font(.title2)
                    .accessibilityIdentifier("start-modifying-button")
                }
              }
            }

          if store.editing {
            IncrementMenu(decrementDisabled: store.dayAmount < 1) {
              send(.addButtonTapped)
            } remove: {
              send(.removeButtonTapped)
            }
            .transition(.move(edge: .trailing))
            .overlay(alignment: .topTrailing) {
              Button { store.editing = false } label: {
                Label("DISMISS", systemImage: "xmark.circle")
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

  @Dependency(\.format) var format

  public init(store: StoreOf<History>) { self.store = store }
}

#Preview {
  HistoryView(store: Store(initialState: History.State(), reducer: History.init))
}
