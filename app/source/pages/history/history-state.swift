// Created by Leopold Lemmermann on 01.04.23.

extension HistoryView {
  struct ViewState: Equatable {
    let dayAmount: Int?,
        configurableAmounts: [IntervalOption: Int],
        untilHereAmount: Int?

    let configurableEntries: [IntervalOption: [Date]]

    init(_ state: App.State, selectedDate: Date) {
      dayAmount = state.calculator?.amount(for: .day(selectedDate))
      configurableAmounts = Dictionary(
        uniqueKeysWithValues: IntervalOption.allCases.compactMap { option in
          state.calculator?.amount(for: option.interval(selectedDate)).flatMap { (option, $0) }
        }
      )
      
      untilHereAmount = state.calculator?.amount(for: .to(selectedDate))

      configurableEntries = Dictionary(
        uniqueKeysWithValues: IntervalOption.allCases.compactMap { option in
          state.calculator?.filtered(for: option.interval(selectedDate)).flatMap { (option, $0) }
        }
      )
    }
  }
}
