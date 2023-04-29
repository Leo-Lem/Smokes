// Created by Leopold Lemmermann on 28.04.23.

import struct Foundation.Date
import struct Foundation.TimeInterval

public extension Calculate {
  struct State: Equatable {
    public internal(set) var entries: Entries.State
    
    internal var filtereds: Filter.State
    internal var filteredAmounts: AmountsFilter.State
    
    internal var amounts: Amounter.State
    internal var averages: Averager.State
    internal var trends: Trender.State
    
    internal var averageBreaks: BreakAverager.State
    
    public init(_ entries: Entries.State = .init()) {
      self.entries = entries
      
      filtereds = .init(entries.array)
      amounts = .init(entries.array)
      
      filteredAmounts = .init(amounts.cache)
      averages = .init(amounts.cache)
      trends = .init(amounts.cache)
      averageBreaks = .init(amounts.cache)
    }
  }
}

public extension Calculate.State {
  func filtered(for interval: Interval) -> [Date]? { filtereds[interval] }
  
  func filteredAmounts(for interval: Interval, by sub: Subdivision) -> [Interval: Int]? {
    filteredAmounts[.init(interval, sub)]
  }
  
  func amount(for interval: Interval) -> Int? { amounts[interval] }
  
  func average(for interval: Interval, by sub: Subdivision) -> Double? {
    averages[.init(entries.clamp(interval), sub)]
  }
  
  func trend(for interval: Interval, by sub: Subdivision) -> Double? {
    trends[.init(entries.clamp(interval), sub)]
  }
  
  func `break`(date: Date) -> TimeInterval? {
    guard let previous = entries.array.last(where: { $0 < date }) else { return .infinity }
    return previous.distance(to: date)
  }
  
  func longestBreak(until date: Date) -> TimeInterval? {
    guard let first = entries.first else { return .infinity }
    
    if entries.count == 1 { return first.distance(to: date) }
    
    return entries.reduce((previousDate: first, longestInterval: TimeInterval.zero)) { result, date in
      (
        previousDate: date,
        longestInterval: max(result.longestInterval, date.timeIntervalSince(result.previousDate))
      )
    }.longestInterval
  }
  
  func averageBreak(_ interval: Interval) -> TimeInterval? { averageBreaks[entries.clamp(interval)] }
}
