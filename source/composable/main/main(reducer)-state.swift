import ComposableArchitecture
import Foundation

extension MainReducer {
  struct State: Equatable {
    var entries = Entries.State()
    var cache = Cache.State()
    var filePorter = File.State()
  }
}

extension MainReducer.State {
  func entries(for interval: Interval) -> [Date]? {
    guard entries.areLoaded else { return nil }
    return entries.entries.filter(interval.contains)
  }
  
  func amount(for interval: Interval) -> Int? { cache[interval] }
  
  func average(for interval: Interval, by subdivision: Subdivision) -> Double? {
    guard let amount = cache[interval] else { return nil }
    
    // TODO: map alltime to fromTo startDate endDate
    
    @Dependency(\.calculator.average) var average
    return average(amount, interval, subdivision)
  }
  
  func trend(for interval: Interval, by subdivision: Subdivision) -> Double? {
    guard !cache.amounts.isEmpty else { return nil }
    
    @Dependency(\.calculator.trend) var trend
    return trend(cache.amounts, interval, subdivision)
  }
  
  func determineTimeSinceLast(for date: Date) -> TimeInterval? {
    guard entries.areLoaded else { return nil }
    
    @Dependency(\.calculator.sinceLast) var timeSinceLast
    return timeSinceLast(entries.entries, date)
  }
  
  func determineLongestBreak(until date: Date) -> TimeInterval? {
    guard entries.areLoaded else { return nil }
    
    @Dependency(\.calculator.longestBreak) var longestBreak
    return longestBreak(entries.entries)
  }
  
  func averageTimeBetween(_ interval: Interval) -> TimeInterval? {
    guard let amount = cache[interval] else { return nil }
    
    @Dependency(\.calculator.averageTimeBetween) var averageTimeBetween
    return averageTimeBetween(amount, interval)
  }
}
