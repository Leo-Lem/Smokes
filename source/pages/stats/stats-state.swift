// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import Foundation

extension StatsView {
  struct ViewState: Equatable {
    let bounds: Interval
    let averageTimeBetween: TimeInterval?
    let configurableAverages: [Subdivision: Double?]
    let configurableTrends: [Subdivision: Double?]
    let configurableEntries: [Subdivision: [Date]?]

    init(_ state: MainReducer.State, interval: Interval) {
      bounds = Interval.fromTo(.init(start: state.entries.startDate, end: .endOfToday))
      
      averageTimeBetween = state.averageTimeBetween(interval)
      
      configurableAverages = Dictionary(
        uniqueKeysWithValues: Subdivision.allCases.map { ($0, state.average(for: interval, by: $0)) }
      )
      
      configurableTrends = Dictionary(
        uniqueKeysWithValues: Subdivision.allCases.map { ($0, state.trend(for: interval, by: $0)) }
      )
      
      configurableEntries = Dictionary(
        uniqueKeysWithValues: Subdivision.allCases.map { ($0, state.entries(for: interval)) }
      )
    }
  }
}
