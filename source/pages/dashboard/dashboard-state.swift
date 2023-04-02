// Created by Leopold Lemmermann on 01.04.23.

import Dependencies
import Foundation

extension DashboardView {
  struct ViewState: Equatable {
    
    let dayAmount: Int?, untilHereAmount: Int?
    let sinceLast: TimeInterval?, longestBreak: TimeInterval?
    let configurableAmounts: [AmountOption: Int?]
    
    init(_ state: MainReducer.State) {
      dayAmount = state.amount(for: .day(.today))
      untilHereAmount = state.amount(for: .to(.endOfToday))
      sinceLast = state.determineTimeSinceLast(for: .today)
      longestBreak = state.determineLongestBreak(until: .today)
      configurableAmounts = Dictionary(
        uniqueKeysWithValues: AmountOption.allCases.map { ($0, state.amount(for: $0.interval)) }
      )
    }
  }
}
