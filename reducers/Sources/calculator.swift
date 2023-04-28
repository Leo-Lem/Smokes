// Created by Leopold Lemmermann on 28.04.23.

import Foundation

public struct Calculator: ReducerProtocol {
  public typealias Filter = Calculate<Interval, [Date], [Date]>
  public typealias Amounter = Calculate<Interval, [Date], Int>
  public typealias Averager = Calculate<IntervalAndSubdivision, [Interval: Int], Double>
  public typealias Trender = Averager
  public typealias AverageBreaker = Calculate<Interval, [Interval: Int], TimeInterval>
  
  public var body: some ReducerProtocol<State, Action> {
    Scope(state: \.filtereds, action: /Action.filtereds) { Filter(filter) }
    Scope(state: \.amounts, action: /Action.amounts) { Amounter(amount) }
    Scope(state: \.averages, action: /Action.averages) { Averager(average) }
    Scope(state: \.trends, action: /Action.trends) { Trender(trend) }
    Scope(state: \.averageBreaks, action: /Action.averageBreaks) { AverageBreaker(averageBreak) }
    
    Reduce<State, Action> { state, action in
      let clamp = state.entries.clamp
      
      switch action {
      case let .amounts(.setResult(amount, for: interval)):
        var amounts = state.averages.data
        amounts[interval] = amount
        return .merge(
          .send(.averages(.setData(amounts))),
          .send(.trends(.setData(amounts))),
          .send(.averageBreaks(.setData(amounts)))
        )
        
      case let .filter(interval):
        return .send(.filtereds(.calculate(clamp(interval))))
        
      case let .amount(interval):
        return .send(.amounts(.calculate(clamp(interval))))
        
      case let .average(interval, sub):
        return .send(.averages(.calculate(.init(clamp(interval), sub))))
        
      case let .trend(interval, sub):
        return .send(.trends(.calculate(.init(clamp(interval), sub))))
        
      case let .averageBreak(interval):
        return .send(.averageBreaks(.calculate(clamp(interval))))
        
      case let .setEntries(entries):
        state.entries = entries
        return .merge(
          .send(.filtereds(.setData(entries.array))),
          .send(.amounts(.setData(entries.array)))
        )
          
      default: break
      }
      
      return .none
    }
  }
}

public extension Calculator {
  struct State: Equatable {
    public internal(set) var entries: Entries.State
    
    internal var filtereds = Filter.State([])
    internal var amounts = Amounter.State([])
    internal var averages = Averager.State([:])
    internal var trends = Trender.State([:])
    internal var averageBreaks = AverageBreaker.State([:])
    
    public init(_ entries: Entries.State) { self.entries = entries }
  }
}

public extension Calculator {
  enum Action {
    case filter(Interval),
         amount(Interval),
         average(Interval, Subdivision),
         trend(Interval, Subdivision),
         averageBreak(Interval)
    
    case setEntries(Entries.State)
    
    case filtereds(Filter.Action),
         amounts(Amounter.Action),
         averages(Averager.Action),
         trends(Trender.Action),
         averageBreaks(AverageBreaker.Action)
  }
}

private extension Calculator {
  func filter(interval: Interval, entries: [Date]) async -> [Date] {
    guard entries.count > 0 else { return [] }

    let startIndex = interval.start.flatMap { start in entries.firstIndex { start <= $0 } } ?? entries.endIndex
    let endIndex = interval.end.flatMap { end in entries.firstIndex { end < $0 } } ?? entries.endIndex
      
    return Array(entries[startIndex ..< endIndex])
  }
  
  func amount(interval: Interval, entries: [Date]) -> Int {
    guard entries.count > 0 else { return 0 }

    return (interval.end.flatMap { end in entries.firstIndex { end < $0 } } ?? entries.endIndex)
      - (interval.start.flatMap { start in entries.firstIndex { start <= $0 } } ?? entries.endIndex)
  }
  
  func average(parameters: IntervalAndSubdivision, amounts: [Interval: Int]) -> Double {
    guard
      let amount = amounts[parameters.interval],
      let length = parameters.interval.count(by: parameters.subdivision)
    else { return 0 }
      
    guard length > 0 else { return .infinity }

    return Double(amount) / Double(length)
  }
    
  func trend(parameters: IntervalAndSubdivision, amounts: [Interval: Int]) -> Double {
    guard
      amounts.count > 0,
      let intervals = parameters.interval.enumerate(by: parameters.subdivision),
      intervals.count > 1
    else { return .infinity }

    return intervals.dropFirst()
      .reduce(into: (trend: 0.0, previous: amounts[intervals.first!] ?? 0)) { result, interval in
        let amount = amounts[interval] ?? 0
        result = (result.trend + Double(amount - result.previous), amount)
      }.trend
      / Double(intervals.count - 1)
  }
  
  func averageBreak(interval: Interval, amounts: [Interval: Int]) -> TimeInterval {
    guard
      let amount = amounts[interval],
      amount > 1
    else { return .infinity }
    
    return interval.duration / Double(amount)
  }
}

extension Calculator.State {
  public func filtered(for interval: Interval) -> [Date]? { filtereds[entries.clamp(interval)] }
  
  public func amount(for interval: Interval) -> Int? { amounts[entries.clamp(interval)] }
  
  public func average(for interval: Interval, by sub: Subdivision) -> Double? {
    averages[.init(entries.clamp(interval), sub)]
  }
  
  public func trend(for interval: Interval, by sub: Subdivision) -> Double? {
    trends[.init(entries.clamp(interval), sub)]
  }
  
  public func `break`(date: Date) -> TimeInterval? {
    guard let previous = entries.array.last(where: { $0 < date }) else { return .infinity }
    return previous.distance(to: date)
  }
  
  public func longestBreak(until date: Date) -> TimeInterval? {
    guard let first = entries.first else { return .infinity }
    
    if entries.count == 1 { return first.distance(to: date) }
    
    return entries.reduce((previousDate: first, longestInterval: TimeInterval.zero)) { result, date in
      (
        previousDate: date,
        longestInterval: max(result.longestInterval, date.timeIntervalSince(result.previousDate))
      )
    }.longestInterval
  }
  
  public func averageBreak(_ interval: Interval) -> TimeInterval? { averageBreaks[entries.clamp(interval)] }
}
