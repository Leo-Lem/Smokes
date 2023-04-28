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
      
      dayAmount = state.calculator.amount(for: .day(now))
      untilHereAmount = state.calculator.amount(for: .to(cal.endOfDay(for: now)))
      configurableAmounts = Dictionary(
        uniqueKeysWithValues: AmountOption.allCases.compactMap { option in
          state.calculator.amount(for: option.interval).flatMap { (option, $0) }
        }
      )
      
      `break` = state.calculator.break(date: now)
      longestBreak = state.calculator.longestBreak(until: now)
      
    }
  }
}
