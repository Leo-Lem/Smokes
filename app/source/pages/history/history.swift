// Created by Leopold Lemmermann on 01.04.23.

import Charts
import ComposableArchitecture
import struct SmokesReducers.Entries
import SwiftUI

struct HistoryView: View {
  @EnvironmentObject private var store: StoreOf<App>

  var body: some View {
    WithViewStore(store, observe: \.entries.array) { .entries($0) } content: { entries in
      Grid {
        if vSize == .regular {
          plotView()

          GridRow {
            configurableAmountView()
            untilHereAmountView()
          }
          .gridCellColumns(4)

          Widget {
            HStack {
              dayAmountView()
                .overlay(alignment: .topTrailing, content: editButton)

              if isEditing {
                incrementView(entries)
                  .transition(.move(edge: .trailing))
                  .overlay(alignment: .topTrailing, content: stopEditButton)
              }
            }
          }
        } else {
          GridRow {
            Grid {
              plotView()

              GridRow {
                configurableAmountView()
                untilHereAmountView()
              }
            }
            .gridCellColumns(3)

            Widget {
              dayAmountView()
                .overlay(alignment: .bottomTrailing, content: editButton)

              if isEditing {
                incrementView(entries)
                  .transition(.move(edge: .bottom))
                  .overlay(alignment: .bottomTrailing, content: stopEditButton)
              }
            }
            .gridCellColumns(0)
          }
        }

        dayPickerView()
          .gridCellColumns(4)
      }
      .labelStyle(.iconOnly)
      .animation(.default, value: CombineHashable(entries.state, isEditing, option, dayAmount, optionAmount, plotData))
      .onAppear { update(option: option, selection: selection, entries: entries.state) }
      .onChange(of: option) { update(option: $0, selection: selection, entries: entries.state) }
      .onChange(of: selection) { update(option: option, selection: $0, entries: entries.state) }
      .onChange(of: entries.state) { update(option: option, selection: selection, entries: $0) }
      .task { await updatePlot(entries.state) }
      .task(id: CombineHashable(selection, option, entries.state)) { await updatePlot(entries.state) }
    }
  }

  @State private var selection = Dependency(\.date.now).wrappedValue - 86400
  @AppStorage("history_intervalOption") private var option = Option.week

  @State private var isEditing = false

  @State private var dayAmount: Int?
  @State private var untilHereAmount: Int?
  @State private var optionAmount: Int?
  @State private var plotData: [Interval: Int]?

  private var interval: Interval { option.interval(selection) }
  private var subdivision: Subdivision { option.subdivision }

  @Environment(\.verticalSizeClass) private var vSize

  @Dependency(\.format) private var format
  @Dependency(\.calculate) private var calculate
}

private extension HistoryView {
  func update(option: Option, selection: Date, entries: [Date]) {
    dayAmount = calculate.amount(.day(selection), entries)
    untilHereAmount = calculate.amount(.to(selection), entries)
    optionAmount = calculate.amount(option.interval(selection), entries)
  }

  func updatePlot(_ entries: [Date]) async {
    plotData = calculate.amounts(option.interval(selection), option.subdivision, entries)
  }
}

private extension HistoryView {
  func dayPickerView() -> some View {
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

  func dayAmountView() -> some View {
    DescriptedValueContent(format.amount(dayAmount), description: "THIS_DAY")
  }

  func incrementView(_ entries: ViewStore<[Date], Entries.Action>) -> some View {
    IncrementMenu(decrementDisabled: dayAmount ?? 0 < 1) {
      entries.send(.add(selection))
    } remove: {
      entries.send(.remove(selection))
    }
  }

  func untilHereAmountView() -> some View {
    Widget {
      DescriptedValueContent(format.amount(untilHereAmount), description: "UNTIL_THIS_DAY")
    }
  }

  func configurableAmountView() -> some View {
    ConfigurableWidget(selection: $option) { option in
      DescriptedValueContent(format.amount(optionAmount), description: option.description)
    }
  }

  func plotView() -> some View {
    Widget {
      AmountsChart(
        plotData?
          .sorted { $0.key < $1.key }
          .map { (format.plotInterval($0, bounds: interval, sub: subdivision) ?? "", $1) },
        description: Text(option.description)
      )
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
