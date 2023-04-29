// Created by Leopold Lemmermann on 01.04.23.

import Dependencies

extension DashboardView {
  struct ViewState: Equatable {
    let dayAmount: Int?,
        untilHereAmount: Int?,
        optionAmount: Int?
    
    let optionTime: TimeInterval?
    
    init(_ state: App.State, option: AmountOption, timeOption: TimeOption) {
      @Dependency(\.calculate) var calculate
      @Dependency(\.calendar) var cal
      @Dependency(\.date.now) var now
      
      let entries = state.entries.array
      
      dayAmount = calculate.amount(.day(now), entries)
      untilHereAmount = calculate.amount(.to(cal.endOfDay(for: now)), entries)
      optionAmount = calculate.amount(option.interval, entries)
      
      switch timeOption {
      case .sinceLast: optionTime = calculate.break(now, entries)
      case .longestBreak: optionTime = calculate.longestBreak(now, entries)
      }
    }
  }
}
