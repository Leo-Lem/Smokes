// Created by Leopold Lemmermann on 01.04.23.

import Dependencies
import Foundation

extension DashboardView {
  struct ViewState: Equatable {
    
    let dayAmount: Int?, untilHereAmount: Int?
    let sinceLast: TimeInterval?, longestBreak: TimeInterval?
    let configurableAmounts: [IntervalOption: Int?]
    
    init(_ state: MainReducer.State) {
      @Dependency(\.date.now) var now: Date
      
      dayAmount = state.amounts[.day]
      untilHereAmount = state.amounts[.untilEndOfDay]
      sinceLast = state.determineTimeSinceLast(for: now)
      longestBreak = state.determineLongestBreak(until: now)
      configurableAmounts = Dictionary(
        uniqueKeysWithValues: IntervalOption.allCases.map { ($0, state.amounts[$0.interval]) }
      )
    }
  }
}
