// Created by Leopold Lemmermann on 01.04.23.

import Charts
import Components
import ComposableArchitecture
import Extensions
import SwiftUI

public struct HistoryView: View {
  @Bindable public var store: StoreOf<History>

  public var body: some View {
    Grid {
      LoadableWithDescription(
        store.plotData?
          .sorted(by: \.key)
          .map { ($0.formatted(.interval(bounds: store.interval, subdivision: store.subdivision)), $1) },
        description: "\(store.option.rawValue)"
      ) {
        AmountsChart($0)
      }
      .widgetStyle()

      GridRow {
        LoadableWithDescription("\(store.optionAmount) smokes", description: "\(store.option.rawValue)")
          .widgetStyle($store.option)

        LoadableWithDescription(store.untilHereAmount.flatMap{"\($0) smokes"}, description: "until here")
          .widgetStyle()
      }

      HStack {
        LoadableWithDescription("\(store.dayAmount) smokes", description: "this day")
          .overlay(alignment: .topTrailing) {
            if !store.editing {
              Button("modify", systemImage: "square.and.pencil") { store.editing = true }
                .font(.title2)
                .accessibilityIdentifier("start-modifying-button")
                .popoverTip(EditTip())
            }
          }

        if store.editing {
          IncrementMenu(decrementDisabled: store.dayAmount < 1) {
            store.send(.addButtonTapped, animation: .default)
          } remove: {
            store.send(.removeButtonTapped, animation: .default)
          }
          .transition(.move(edge: .trailing))
          .overlay(alignment: .topTrailing) {
            Button("dismiss", systemImage: "xmark.circle") { store.editing = false }
              .font(.title2)
              .accessibilityIdentifier("stop-modifying-button")
          }
        }
      }
      .widgetStyle()
      .labelStyle(.iconOnly)

      DayPicker(selection: $store.selection, bounds: store.bounds)
        .labelStyle(.iconOnly)
        .buttonStyle(.borderedProminent)
        .widgetStyle()
        .gridCellColumns(2)
    }
    .animation(.default, values: CombineHashable(store.editing, store.selection, store.option))
  }

  public init(store: StoreOf<History>) { self.store = store }
}

#Preview {
  HistoryView(store: Store(initialState: History.State(), reducer: History.init))
    .padding()
}
