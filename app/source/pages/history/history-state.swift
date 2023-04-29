// Created by Leopold Lemmermann on 01.04.23.

extension HistoryView {
  struct ViewState: Equatable {
    let dayAmount: Int?,
        untilHereAmount: Int?,
        configurableAmounts: [Option: Int]

    let configurableEntries: [Option: [Date]]

    init(_ state: App.State, selectedDate: Date) {
      dayAmount = state.calculate.amount(for: .day(selectedDate))
      untilHereAmount = state.calculate.amount(for: .to(selectedDate))
      
      configurableAmounts = Dictionary(
        uniqueKeysWithValues: Option.allCases.compactMap { option in
          state.calculate.amount(for: option.interval(selectedDate)).flatMap { (option, $0) }
        }
      )
      
      configurableEntries = Dictionary(
        uniqueKeysWithValues: Option.allCases.compactMap { option in
          state.calculate.filtered(for: option.interval(selectedDate)).flatMap { (option, $0) }
        }
      )
    }
  }
}
