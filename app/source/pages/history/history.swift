// Created by Leopold Lemmermann on 01.04.23.

import Charts
import ComposableArchitecture
import SwiftUI

struct HistoryView: View {
  @EnvironmentObject private var store: StoreOf<App>

  var body: some View {
    WithViewStore(store) {
      ViewState($0, selection: selection)
    } send: {
      ViewAction.send($0, selection: selection)
    } content: { vs in
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
      .onAppear { ViewAction.update(vs, option: option) }
      .onChange(of: selection) { _ in ViewAction.update(vs, option: option) }
      .onChange(of: option) { ViewAction.update(vs, option: $0) }
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

private extension HistoryView {
  func dayPickerWidget() -> some View {
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

  func dayAmount(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    DescriptedValueContent(formatter.format(amount: vs.dayAmount), description: "THIS_DAY")
  }

  func increment(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    IncrementMenu(decrementDisabled: vs.dayAmount ?? 0 < 1) { vs.send(.add) } remove: { vs.send(.remove) }
  }

  func untilHereAmountWidget(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    Widget {
      DescriptedValueContent(formatter.format(amount: vs.untilHereAmount), description: "UNTIL_THIS_DAY")
    }
  }

  func configurableAmountWidget(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    ConfigurableWidget(selection: $option) { option in
      DescriptedValueContent(formatter.format(amount: vs.amounts[option]), description: option.description)
    }
  }

  func amountsPlotWidget(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    let data = vs.plotData[option]
      .flatMap { prepareAmountsForPlotting($0, bounds: option.interval(selection), subdivision: option.subdivision) }
    
    return Widget {
      AmountsChart(data, description: Text(option.description))
    }
  }

  @ViewBuilder func editButton() -> some View {
    if !isEditing {
      Button { isEditing = true } label: {
        Label("MODIFY", systemImage: "square.and.pencil")
          .font(.title2)
          .accessibilityIdentifier("start-modifying-button")
      }
    }
  }

  @ViewBuilder func stopEditButton() -> some View {
    if isEditing {
      Button { isEditing = false } label: {
        Label("DISMISS", systemImage: "xmark.circle")
          .font(.title2)
          .accessibilityIdentifier("stop-modifying-button")
      }
    }
  }
}

func plotLabelFormatting(_ bounds: Interval, _ subdivision: Subdivision) -> Date.FormatStyle {
  switch (bounds, subdivision) {
  case (.week, .day): return .init().weekday(.abbreviated)
  case (.month, .day): return .init().day(.twoDigits)
  case (.month, .week): return .init().week(.weekOfMonth)
  case (.year, .day): return .init().day(.twoDigits).month(.twoDigits)
  case (.year, .week): return .init().week(.twoDigits)
  case (.year, .month): return .init().month(.abbreviated)
  case (_, .day): return .init().day(.twoDigits).month(.abbreviated).year(.defaultDigits)
  case (_, .week): return .init().week(.twoDigits).year(.defaultDigits)
  case (_, .month): return .init().month(.abbreviated).year(.defaultDigits)
  case (_, .year): return .init().year(.defaultDigits)
  }
}

// !!!: can only be used with a countable interval
func prepareAmountsForPlotting(
  _ amounts: [Interval: Int], bounds: Interval, subdivision: Subdivision
) -> [(String, Int)] {
  amounts
    .sorted { $0.key.start! < $1.key.start! }
    .map { interval, amount in (interval.end!.formatted(plotLabelFormatting(bounds, subdivision)), amount) }
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
