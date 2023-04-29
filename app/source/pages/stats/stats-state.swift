// Created by Leopold Lemmermann on 01.04.23.

extension StatsView {
  struct ViewState: Equatable {
    let bounds: Interval
    let averageTimeBetween: TimeInterval?
    let configurableAverages: [Option: Double]
    let configurableTrends: [Option: Double]
    let configurableEntries: [PlotOption: [Date]]

    init(_ state: App.State, interval: Interval) {
      bounds = state.entries.clamp(.alltime)
      
      averageTimeBetween = state.calculate.averageBreak(interval)
      
      configurableAverages = Dictionary(
        uniqueKeysWithValues: Option.allCases.compactMap { option in
          state.calculate.average(for: interval, by: option.subdivision).flatMap { (option, $0) }
        }
      )
      
      configurableTrends = Dictionary(
        uniqueKeysWithValues: Option.allCases.compactMap { option in
          state.calculate.trend(for: interval, by: option.subdivision).flatMap { (option, $0) }
        }
      )
      
      configurableEntries = Dictionary(
        uniqueKeysWithValues: PlotOption.allCases
          .compactMap { option in state.calculate.filtered(for: interval).flatMap { (option, $0) } }
      )
    }
  }
}
