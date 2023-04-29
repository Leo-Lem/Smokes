// Created by Leopold Lemmermann on 01.04.23.

import Dependencies

extension HistoryView {
  struct ViewState: Equatable {
    let dayAmount: Int?,
        untilHereAmount: Int?,
        optionAmount: Int?

    let optionPlotData: [Interval: Int]?

    init(_ state: App.State, selection: Date, option: Option) {
      @Dependency(\.calculate) var calculate
      
      let entries = state.entries.array
      
      dayAmount = calculate.amount(.day(selection), entries)
      untilHereAmount = calculate.amount(.to(selection), entries)
      optionAmount = calculate.amount(option.interval(selection), entries)
      
      optionPlotData = calculate.amounts(option.interval(selection), option.subdivision, entries)
    }
  }
}
