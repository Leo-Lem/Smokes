// Created by Leopold Lemmermann on 01.04.23.

import Dependencies

extension StatsView {
  struct ViewState: Equatable {
    let bounds: Interval
    
    let optionAverage: Double?
    let optionTrend: Double?
    
    let averageTimeBetween: TimeInterval?
    
    let optionPlotData: [Interval: Int]?

    init(_ state: App.State, selection: Interval, option: Option, plotOption: PlotOption) {
      @Dependency(\.calculate) var calculate
      
      let entries = state.entries.array
      let clamp = state.entries.clamp
      let selection = clamp(selection)
      
      bounds = clamp(.alltime)
      
      optionAverage = calculate.average(selection, option.subdivision, entries)
      optionTrend = selection == .alltime ? nil : calculate.trend(selection, option.subdivision, entries)
      
      averageTimeBetween = calculate.averageBreak(selection, entries)
      
      optionPlotData = calculate.amounts(selection, plotOption.subdivision, entries)
    }
  }
}
