// Created by Leopold Lemmermann on 01.04.23.

extension DashboardView {
  struct ViewState: Equatable {
    let dayAmount: Int?,
        untilHereAmount: Int?,
        configurableAmounts: [AmountOption: Int?]
    
    let `break`: TimeInterval?,
        longestBreak: TimeInterval?
    
    init(_ state: App.State) {
      @Dependency(\.calendar) var cal
      @Dependency(\.date.now) var now
      
      dayAmount = state.calculator.amount(for: .day(now))
      untilHereAmount = state.calculator.amount(for: .to(cal.endOfDay(for: now)))
      configurableAmounts = Dictionary(
        uniqueKeysWithValues: AmountOption.allCases.map { ($0, state.calculator.amount(for: $0.interval)) }
      )
      
      `break` = state.calculator.break(date: now)
      longestBreak = state.calculator.longestBreak(until: now)
      
    }
  }
}
