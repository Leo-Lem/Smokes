// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import Foundation

extension StatsView {
  struct ViewState: Equatable {
    let bounds: Interval
    let averageTimeBetween: TimeInterval?
    let configurableAverages: [Option: Double?]
    let configurableTrends: [Option: Double?]
    let configurableEntries: [Option: [Date]?]

    init(_ state: MainReducer.State, interval: Interval) {
      bounds = Interval.fromTo(.init(start: state.entries.startDate, end: .endOfToday))
      
      averageTimeBetween = state.averageTimeBetween(interval)
      
      configurableAverages = Dictionary(
        uniqueKeysWithValues: Option.allCases.map { ($0, state.average(for: interval, by: $0.subdivision)) }
      )
      
      configurableTrends = Dictionary(
        uniqueKeysWithValues: Option.allCases.map { ($0, state.trend(for: interval, by: $0.subdivision)) }
      )
      
      configurableEntries = Dictionary(
        uniqueKeysWithValues: Option.allCases.map { ($0, state.entries(for: interval)) }
      )
    }
  }
}
