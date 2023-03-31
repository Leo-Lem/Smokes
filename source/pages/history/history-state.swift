// Created by Leopold Lemmermann on 01.04.23.

import Foundation

extension HistoryView {
  struct ViewState: Equatable {
    let dayAmount: Int?
    let untilHereAmount: Int?
    let configurableAmounts: [IntervalOption: Int?]
    let configurableEntries: [IntervalOption: [Date]?]

    init(_ state: MainReducer.State, selectedDate: Date) {
      dayAmount = state.amounts[.day(of: selectedDate)]
      untilHereAmount = state.amounts[.untilEndOfDay(of: selectedDate)]
      configurableAmounts = Dictionary(
        uniqueKeysWithValues: IntervalOption.allCases.compactMap { ($0, state.amounts[$0.interval(selectedDate)]) }
      )
      configurableEntries = Dictionary(
        uniqueKeysWithValues: IntervalOption.allCases.compactMap { ($0, state.entries(in: $0.interval(selectedDate))) }
      )
    }
  }
}
