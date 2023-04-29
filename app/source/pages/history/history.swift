// Created by Leopold Lemmermann on 01.04.23.

import Charts
import ComposableArchitecture
import SwiftUI

struct HistoryView: View {
  @EnvironmentObject private var store: StoreOf<App>

  var body: some View {
    WithViewStore(store) { ViewState($0, selectedDate: selection) } send: { ViewAction.send($0) } content: { vs in
      Grid {
        if vSize == .regular {
          amountsPlotWidget(vs)

          GridRow {
            configurableAmountWidget(vs)
            untilHereAmountWidget(vs)
          }

          Widget {
            HStack {
              dayAmount(vs)
                .overlay(alignment: .topTrailing, content: editButton)

              if isEditing {
                increment(vs)
                  .transition(.move(edge: .trailing))
                  .overlay(alignment: .topTrailing, content: stopEditButton)
              }
            }
          }
        } else {
          GridRow {
            Grid {
              amountsPlotWidget(vs)

              GridRow {
                configurableAmountWidget(vs)
                untilHereAmountWidget(vs)
              }
            }

            Widget {
              dayAmount(vs)
                .overlay(alignment: .bottomTrailing, content: editButton)

              if isEditing {
                increment(vs)
                  .transition(.move(edge: .bottom))
                  .overlay(alignment: .bottomTrailing, content: stopEditButton)
              }
            }
          }
        }

        dayPickerWidget()
      }
      .labelStyle(.iconOnly)
      .animation(.default, value: vs.state)
      .animation(.default, value: isEditing)
      .animation(.default, value: option)
      .onAppear { ViewAction.update(vs, selection: selection, option: option) }
      .onChange(of: selection) { ViewAction.update(vs, selection: $0, option: option) }
      .onChange(of: option) { ViewAction.update(vs, selection: selection, option: $0) }
    }
  }

  @State private var selection = {
    @Dependency(\.date.now) var now
    return now - 86400
  }()

  @State private var isEditing = false
  @AppStorage("history_intervalOption") private var option = Option.week

  @Environment(\.verticalSizeClass) private var vSize

  @Dependency(\.formatter) private var formatter
}

extension HistoryView {
  private func dayPickerWidget() -> some View {
    let bounds = {
      @Dependency(\.calendar) var cal
      @Dependency(\.date.now) var now
      return Interval.to(cal.endOfDay(for: now))
    }()

    return Widget {
      DayPicker(selection: $selection, bounds: bounds)
        .labelStyle(.iconOnly)
        .buttonStyle(.borderedProminent)
    }
  }

  private func dayAmount(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    DescriptedValueContent(formatter.format(amount: vs.dayAmount), description: "THIS_DAY")
  }

  private func increment(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    IncrementMenu(decrementDisabled: vs.dayAmount ?? 0 < 1) {
      vs.send(.add(selection))
    } remove: {
      vs.send(.remove(selection))
    }
  }

  private func untilHereAmountWidget(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    Widget {
      DescriptedValueContent(formatter.format(amount: vs.untilHereAmount), description: "UNTIL_THIS_DAY")
    }
  }

  private func configurableAmountWidget(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    ConfigurableWidget(selection: $option) { option in
      DescriptedValueContent(formatter.format(amount: vs.configurableAmounts[option]), description: option.description)
    }
  }

  private func amountsPlotWidget(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    Widget {
      
    }
  }

  @ViewBuilder private func editButton() -> some View {
    if !isEditing {
      Button { isEditing = true } label: {
        Label("MODIFY", systemImage: "square.and.pencil")
          .font(.title2)
          .accessibilityIdentifier("start-modifying-button")
      }
    }
  }

  @ViewBuilder private func stopEditButton() -> some View {
    if isEditing {
      Button { isEditing = false } label: {
        Label("DISMISS", systemImage: "xmark.circle")
          .font(.title2)
          .accessibilityIdentifier("stop-modifying-button")
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct HistoryView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      HistoryView()
        .environment(\.verticalSizeClass, .regular)
        .previewDisplayName("Regular")

      HistoryView()
        .environment(\.verticalSizeClass, .compact)
        .previewDisplayName("Compact")
    }
    .padding()
    .environmentObject(Store(initialState: .init(), reducer: App()))
  }
}
#endif
