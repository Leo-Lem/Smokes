// Created by Leopold Lemmermann on 01.04.23.

extension HistoryView {
  struct ViewState: Equatable {
    let dayAmount: Int?,
        untilHereAmount: Int?,
        amounts: [Option: Int]

    let plotData: [Option: [Interval: Int]]

    init(_ state: App.State, selection: Date) {
      dayAmount = state.calculate.amount(for: .day(selection))
      untilHereAmount = state.calculate.amount(for: .to(selection))
      
      amounts = Dictionary(
        uniqueKeysWithValues: Option.allCases.compactMap { option in
          state.calculate.amount(for: option.interval(selection))
            .flatMap { (option, $0) }
        }
      )
      
      plotData = Dictionary(
        uniqueKeysWithValues: Option.allCases.compactMap { option in
          state.calculate.filteredAmounts(for: option.interval(selection), by: option.subdivision)
            .flatMap { (option, $0) }
        }
      )
    }
  }
}
