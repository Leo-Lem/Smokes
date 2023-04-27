// Created by Leopold Lemmermann on 01.04.23.

import Dependencies
import Foundation

extension DashboardView {
  struct ViewState: Equatable {
    
    let dayAmount: Int?,
        untilHereAmount: Int?,
        configurableAmounts: [AmountOption: Int?]
    
    let `break`: TimeInterval?,
        longestBreak: TimeInterval?
    
    init(_ state: MainReducer.State) {
      dayAmount = state.amount(for: .day(.today))
      untilHereAmount = state.amount(for: .to(.endOfToday))
      configurableAmounts = Dictionary(
        uniqueKeysWithValues: AmountOption.allCases.map { ($0, state.amount(for: $0.interval)) }
      )
      
      `break` = state.break(for: .today)
      longestBreak = state.longestBreak(until: .today)
      
    }
  }
}
