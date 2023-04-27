// Created by Leopold Lemmermann on 01.04.23.

import Foundation

extension HistoryView {
  struct ViewState: Equatable {
    let dayAmount: Int?,
        configurableAmounts: [IntervalOption: Int?],
        untilHereAmount: Int?
    
    let configurableEntries: [IntervalOption: [Date]?]

    init(_ state: MainReducer.State, selectedDate: Date) {
      dayAmount = state.amount(for: .day(selectedDate))
      configurableAmounts = Dictionary(
        uniqueKeysWithValues: IntervalOption.allCases.compactMap { ($0, state.amount(for: $0.interval(selectedDate))) }
      )
      untilHereAmount = state.amount(for: .to(selectedDate))
      
      configurableEntries = Dictionary(
        uniqueKeysWithValues: IntervalOption.allCases.compactMap { ($0, state.entries(for: $0.interval(selectedDate))) }
      )
    }
  }
}
