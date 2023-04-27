import ComposableArchitecture
import Foundation

struct Calculate: ReducerProtocol {
  typealias Filter = Calculator<Interval, [Date], [Date]>
  
  typealias Amounter = Calculator<Interval, [Date], Int>
  typealias Averager = Calculator<IntervalAndSubdivision, [Interval: Int], Double>
  typealias Trender = Calculator<IntervalAndSubdivision, [Interval: Int], Double>
  
  typealias Breaker = Calculator<Date, [Date], TimeInterval>
  typealias LongestBreaker = Calculator<Date, [Date], TimeInterval>
  typealias AverageBreaker = Calculator<Interval, [Interval: Int], TimeInterval>
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.filtereds, action: /Action.filtereds) { Filter(filter) }
    Scope(state: \.amounts, action: /Action.amounts) { Amounter(amount) }
    Scope(state: \.averages, action: /Action.averages) { Averager(average) }
    Scope(state: \.trends, action: /Action.trends) { Trender(trend) }
    Scope(state: \.breaks, action: /Action.breaks) { Breaker(`break`) }
    Scope(state: \.longestBreaks, action: /Action.longestBreaks) { LongestBreaker(longestBreak) }
    Scope(state: \.averageBreaks, action: /Action.averageBreaks) { AverageBreaker(averageBreak) }
    
    Reduce<State, Action> { state, action in
      switch action {
      case let .filter(interval):
        return .send(.filtereds(.calculate(interval)))
        
      case let .amount(interval):
        return .send(.amounts(.calculate(interval)))
        
      case let .average(interval, subdivision):
        return .run { send in
          await send(.amount(interval))
          await send(.averages(.calculate(.init(interval, subdivision))))
        }
        
      case let .trend(interval, subdivision):
        return .run { send in
          for interval in interval.enumerate(by: subdivision) ?? [] { await send(.amount(interval)) }
          await send(.trends(.calculate(.init(interval, subdivision))))
        }
        
      case let .break(date):
        return .send(.breaks(.calculate(date)))
        
      case let .longestBreak(date):
        return .send(.longestBreaks(.calculate(date)))
        
      case let .averageBreak(interval):
        return .run { send in
          await send(.amount(interval))
          await send(.averageBreaks(.calculate(interval)))
        }
        
      case let .updateEntries(entries):
        return .run { send in
          await send(.amounts(.setData(entries)))
          await send(.filtereds(.setData(entries)))
          await send(.breaks(.setData(entries)))
          await send(.longestBreaks(.setData(entries)))
        }
        
      case let .updateAmounts(amounts):
        return .run { send in
          await send(.averages(.setData(amounts)))
          await send(.trends(.setData(amounts)))
          await send(.averageBreaks(.setData(amounts)))
        }
        
      case let .amounts(.cache(.insert(interval, amount))):
        var amounts = state.averages.data
        amounts[interval] = amount
        return .send(.updateAmounts(amounts))
        
      default:
        break
      }
      return .none
    }
  }
}

extension Calculate {
  struct State: Equatable {
    var filtereds = Filter.State([])
    
    var amounts = Amounter.State([])
    var averages = Averager.State([:])
    var trends = Trender.State([:])
    
    var breaks = Breaker.State([])
    var longestBreaks = LongestBreaker.State([])
    var averageBreaks = AverageBreaker.State([:])
  }
}

extension Calculate {
  enum Action {
    case filtereds(Filter.Action),
         filter(Interval)
    
    case setEntries([Date]),
         setAmounts([Interval: Int])
    
    case amounts(Amounter.Action),
         amount(Interval)
    
    case averages(Averager.Action),
         average(Interval, Subdivision)
    
    case trends(Trender.Action),
         trend(Interval, Subdivision)
    
    case breaks(Breaker.Action),
         `break`(Date)
    
    case longestBreaks(LongestBreaker.Action),
         longestBreak(_ until: Date)
    
    case averageBreaks(AverageBreaker.Action),
         averageBreak(Interval)
    
    case updateEntries([Date]),
         updateAmounts([Interval: Int])
  }
}

extension Calculate {
  private func filter(interval: Interval, entries: [Date]) async -> [Date] {
    guard entries.count > 0 else { return [] }

    let startIndex = interval.start.flatMap { start in entries.firstIndex { start <= $0 } } ?? entries.endIndex
    let endIndex = interval.end.flatMap { end in entries.firstIndex { end < $0 } } ?? entries.endIndex
      
    return Array(entries[startIndex ..< endIndex])
  }
  
  private func amount(interval: Interval, entries: [Date]) -> Int {
    guard entries.count > 0 else { return 0 }

    return (interval.end.flatMap { end in entries.firstIndex { end < $0 } } ?? entries.endIndex)
      - (interval.start.flatMap { start in entries.firstIndex { start <= $0 } } ?? entries.endIndex)
  }
  
  private func average(parameters: IntervalAndSubdivision, amounts: [Interval: Int]) -> Double {
    guard
      let amount = amounts[parameters.interval],
      let length = parameters.interval.count(by: parameters.subdivision)
    else { return 0 }
      
    guard length > 0 else { return .infinity }

    return Double(amount) / Double(length)
  }
    
  private func trend(parameters: IntervalAndSubdivision, amounts: [Interval: Int]) -> Double {
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
  
  private func `break`(date: Date, entries: [Date]) -> TimeInterval {
    if let previous = entries.last(where: { $0 < date }) {
      return previous.distance(to: date)
    } else { return .infinity }
  }
  
  private func longestBreak(until date: Date, entries: [Date]) -> TimeInterval {
    guard let first = entries.first else { return .infinity }
    
    if entries.count == 1 { return first.distance(to: date) }
    
    return entries.reduce((previousDate: first, longestInterval: TimeInterval.zero)) { result, date in
      (
        previousDate: date,
        longestInterval: max(result.longestInterval, date.timeIntervalSince(result.previousDate))
      )
    }.longestInterval
  }
  
  private func averageBreak(interval: Interval, amounts: [Interval: Int]) -> TimeInterval {
    guard
      let amount = amounts[interval],
      amount > 1
    else { return .infinity }
    
    return interval.duration / Double(amount)
  }
}
