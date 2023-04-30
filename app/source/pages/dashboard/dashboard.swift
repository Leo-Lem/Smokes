// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import struct SmokesReducers.Entries
import SwiftUI

struct DashboardView: View {
  @EnvironmentObject private var store: StoreOf<App>
  
  var body: some View {
    WithViewStore(store, observe: \.entries.array) { .entries($0) } content: { entries in
      Grid {
        if vSize == .regular {
          dayAmountWidget()

          GridRow {
            configurableAmountWidget()
            configurableTimeWidget()
          }
          
          GridRow {
            untilNowAmountWidget(porterButtonAlignment: .bottomLeading)
            incrementWidget(entries)
          }
        } else {
          GridRow {
            dayAmountWidget().gridCellColumns(2)
            configurableAmountWidget()
          }
            
          GridRow {
            untilNowAmountWidget(porterButtonAlignment: .bottomLeading)
            configurableTimeWidget()
            incrementWidget(entries)
          }
        }
      }
      .animation(.default, value: CombineHashable(
        entries.state, amountOption, timeOption, dayAmount, untilHereAmount, optionAmount, optionTime
      ))
      .onAppear { update(entries: entries.state) }
      .onChange(of: entries.state, perform: update)
      .onChange(of: amountOption) { update(amountOption: $0, entries: entries.state) }
      .onChange(of: timeOption) { update(timeOption: $0, entries: entries.state) }
    }
  }
  
  @AppStorage("dashboard_amountOption") private var amountOption = AmountOption.week
  @AppStorage("dashboard_timeOption") private var timeOption = TimeOption.sinceLast
  
  @State private var showingPorter = false
  
  @State private var dayAmount: Int?
  @State private var untilHereAmount: Int?
  @State private var optionAmount: Int?
  @State private var optionTime: TimeInterval?
  
  @Environment(\.verticalSizeClass) private var vSize
  
  @Dependency(\.calendar) var cal
  @Dependency(\.date.now) var now
  @Dependency(\.format) private var format
  @Dependency(\.calculate) var calculate
}

private extension DashboardView {
  func update(entries: [Date]) {
    dayAmount = calculate.amount(.day(now), entries)
    untilHereAmount = calculate.amount(.to(cal.endOfDay(for: now)), entries)
    update(amountOption: amountOption, entries: entries)
    update(timeOption: timeOption, entries: entries)
  }
  
  func update(amountOption: AmountOption, entries: [Date]) {
    optionAmount = calculate.amount(amountOption.interval, entries)
  }
  
  func update(timeOption: TimeOption, entries: [Date]) {
    switch timeOption {
    case .sinceLast: optionTime = calculate.break(now, entries)
    case .longestBreak: optionTime = calculate.longestBreak(now, entries)
    }
  }
}

private extension DashboardView {
  func dayAmountWidget() -> some View {
    Widget {
      DescriptedValueContent(format.amount(dayAmount), description: "TODAY")
    }
  }
  
  func untilNowAmountWidget(porterButtonAlignment: Alignment) -> some View {
    Widget {
      DescriptedValueContent(format.amount(untilHereAmount), description: "UNTIL_NOW")
        .overlay(alignment: porterButtonAlignment) {
          Button { showingPorter = true } label: { Label("OPEN_PORTER", systemImage: "folder") }
            .labelStyle(.iconOnly)
            .accessibilityIdentifier("show-porter-button")
        }
        .sheet(isPresented: $showingPorter) { Porter().padding() }
    }
  }
  
  func configurableAmountWidget() -> some View {
    ConfigurableWidget(selection: $amountOption) { option in
      DescriptedValueContent(format.amount(optionAmount), description: option.description)
    }
  }
  
  func configurableTimeWidget() -> some View {
    ConfigurableWidget(selection: $timeOption) { option in
      DescriptedValueContent(format.time(optionTime), description: option.description)
    }
  }
  
  func incrementWidget(_ entries: ViewStore<[Date], Entries.Action>) -> some View {
    Widget {
      IncrementMenu(decrementDisabled: dayAmount ?? 0 <= 0) {
        entries.send(.add(now))
      } remove: {
        entries.send(.remove(now))
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct DashboardView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      DashboardView()
        .environment(\.verticalSizeClass, .regular)
        .previewDisplayName("Regular")

      DashboardView()
        .environment(\.verticalSizeClass, .compact)
        .previewDisplayName("Compact")
    }
    .padding()
    .environmentObject(Store(initialState: .init(), reducer: App()))
  }
}
#endif
