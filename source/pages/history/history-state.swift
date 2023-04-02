// Created by Leopold Lemmermann on 01.04.23.

import Foundation

extension HistoryView {
  struct ViewState: Equatable {
    let dayAmount: Int?
    let untilHereAmount: Int?
    let configurableAmounts: [IntervalOption: Int?]
    let configurableEntries: [IntervalOption: [Date]?]

    init(_ state: MainReducer.State, selectedDate: Date) {
      dayAmount = state.amount(for: .day(selectedDate))
      untilHereAmount = state.amount(for: .to(selectedDate))
      configurableAmounts = Dictionary(
        uniqueKeysWithValues: IntervalOption.allCases.compactMap { ($0, state.amount(for: $0.interval(selectedDate))) }
      )
      configurableEntries = Dictionary(
        uniqueKeysWithValues: IntervalOption.allCases.compactMap { ($0, state.entries(for: $0.interval(selectedDate))) }
      )
    }
  }
}
