// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import Foundation

extension StatsView {
  struct ViewState: Equatable {
    let bounds: DateInterval
    let averageTimeBetween: TimeInterval?
    let configurableAverages: [AverageOption: Double?]
    let configurableTrends: [AverageOption: Double?]
    let configurableEntries: [AverageOption: [Date]]

    init(_ state: MainReducer.State, selectedInterval: DateInterval) {
      bounds = state.validInterval
      
      let interval = selectedInterval.intersection(with: bounds) ?? .init()
      
      averageTimeBetween = state.averageTimeBetween(interval)
      
      configurableAverages = Dictionary(
        uniqueKeysWithValues: AverageOption.allCases.map { ($0, state.average(interval, by: $0.comp)) }
      )
      
      configurableTrends = Dictionary(
        uniqueKeysWithValues: AverageOption.allCases.map { ($0, state.trend(interval, by: $0.comp)) }
      )
      
      configurableEntries = Dictionary(
        uniqueKeysWithValues: AverageOption.allCases.map { ($0, state.entries(in: interval)) }
      )
    }
  }
}
