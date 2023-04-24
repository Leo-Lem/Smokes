import Charts
import ComposableArchitecture
import SwiftUI

struct HistoryView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store) {
      ViewState($0, selectedDate: selectedDate)
    } send: {
      ViewAction.send($0, selectedDate: selectedDate)
    } content: { vs in
      Grid {
        if vSize == .regular {
          amountsPlotWidget(vs.configurableEntries[intervalOption]?.optional, option: intervalOption)

          GridRow {
            configurableAmountWidget { vs.configurableAmounts[$0]?.optional }
            untilHereAmountWidget(vs.untilHereAmount)
          }

          Widget {
            HStack {
              dayAmount(vs.dayAmount)
                .overlay(alignment: .topTrailing, content: editButton)

              if isEditing {
                increment(decrementDisabled: vs.dayAmount ?? 0 < 1) { vs.send(.add) } remove: { vs.send(.remove) }
                  .transition(.move(edge: .trailing))
                  .overlay(alignment: .topTrailing, content: stopEditButton)
              }
            }
          }
        } else {
          GridRow {
            Grid {
              amountsPlotWidget(vs.configurableEntries[intervalOption]?.optional, option: intervalOption)

              GridRow {
                configurableAmountWidget { vs.configurableAmounts[$0]?.optional }
                untilHereAmountWidget(vs.untilHereAmount)
              }
            }

            Widget {
              dayAmount(vs.dayAmount)
                .overlay(alignment: .bottomTrailing, content: editButton)

              if isEditing {
                increment(decrementDisabled: vs.dayAmount ?? 0 < 1) { vs.send(.add) } remove: { vs.send(.remove) }
                  .transition(.move(edge: .bottom))
                  .overlay(alignment: .bottomTrailing, content: stopEditButton)
              }
            }
          }
        }

        dayPickerWidget($selectedDate)
      }
      .labelStyle(.iconOnly)
      .animation(.default, value: vs.state)
      .animation(.default, value: isEditing)
      .animation(.default, value: intervalOption)
      .onAppear {
        vs.send(.loadDay())
        vs.send(.loadUntilHere())
        IntervalOption.allCases.forEach { vs.send(.loadOption($0)) }
      }
      .onChange(of: selectedDate) { new in
        vs.send(.loadDay(new))
        vs.send(.loadUntilHere(new))
        IntervalOption.allCases.forEach { vs.send(.loadOption($0, date: new)) }
      }
    }
  }

  @State private var selectedDate = Date.yesterday
  @State private var isEditing = false
  @AppStorage("history_intervalOption") private var intervalOption = IntervalOption.week

  @Environment(\.verticalSizeClass) private var vSize

  @Dependency(\.formatter) private var formatter
}

extension HistoryView {
  private func dayPickerWidget(_ selectedDate: Binding<Date>) -> some View {
    Widget {
      DayPicker(selection: selectedDate, bounds: Interval.to(.endOfToday).dateInterval)
        .labelStyle(.iconOnly)
        .buttonStyle(.borderedProminent)
    }
  }

  private func dayAmount(_ amount: Int?) -> some View {
    DescriptedValueContent(formatter.format(amount: amount), description: "THIS_DAY")
  }

  private func increment(
    decrementDisabled: Bool, add: @escaping () -> Void, remove: @escaping () -> Void
  ) -> some View {
    IncrementMenu(decrementDisabled: decrementDisabled, add: add, remove: remove)
  }

  private func untilHereAmountWidget(_ amount: Int?) -> some View {
    Widget {
      DescriptedValueContent(formatter.format(amount: amount), description: "UNTIL_THIS_DAY")
    }
  }

  private func configurableAmountWidget(_ amount: @escaping (IntervalOption) -> Int?) -> some View {
    ConfigurableWidget(selection: $intervalOption) { option in
      DescriptedValueContent(formatter.format(amount: amount(option)), description: option.description)
    }
  }

  private func amountsPlotWidget(_ entries: [Date]?, option: IntervalOption) -> some View {
    Widget {
      AmountsChart(
        entries: entries,
        bounds: option.interval(selectedDate),
        subdivision: option.subdivision,
        description: Text(option.description)
      )
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
    .environmentObject(Store(initialState: .init(), reducer: MainReducer()))
  }
}
#endif
