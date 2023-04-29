// Created by Leopold Lemmermann on 01.04.23.

extension DashboardView {
  struct ViewState: Equatable {
    let dayAmount: Int?,
        untilHereAmount: Int?,
        configurableAmounts: [AmountOption: Int]
    
    let `break`: TimeInterval?,
        longestBreak: TimeInterval?
    
    init(_ state: App.State) {
      @Dependency(\.calendar) var cal
      @Dependency(\.date.now) var now
      
      dayAmount = state.calculate.amount(for: .day(now))
      untilHereAmount = state.calculate.amount(for: .to(cal.endOfDay(for: now)))
      configurableAmounts = Dictionary(
        uniqueKeysWithValues: AmountOption.allCases.compactMap { option in
          state.calculate.amount(for: option.interval).flatMap { (option, $0) }
        }
      )
      
      `break` = state.calculate.break(date: now)
      longestBreak = state.calculate.longestBreak(until: now)
      
    }
  }
}
