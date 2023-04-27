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
    Scope(state: \.filtereds, action: /Action.filtereds) {
      Filter { interval, entries in
        guard entries.count > 0 else { return [] }

        let startIndex = interval.start.flatMap { start in entries.firstIndex { start <= $0 } } ?? entries.endIndex
        let endIndex = interval.end.flatMap { end in entries.firstIndex { end < $0 } } ?? entries.endIndex
          
        return Array(entries[startIndex ... endIndex])
      }
    }
    
    Scope(state: \.amounts, action: /Action.amounts) {
      Amounter { interval, entries in
        guard entries.count > 0 else { return 0 }

        return (interval.end.flatMap { end in entries.firstIndex { end < $0 } } ?? entries.endIndex)
          - (interval.start.flatMap { start in entries.firstIndex { start <= $0 } } ?? entries.endIndex)
      }
    }
      
    Scope(state: \.averages, action: /Action.averages) {
      Averager { parameters, amounts in
        guard
          let amount = amounts[parameters.interval],
          let length = parameters.interval.count(by: parameters.subdivision)
        else { return 0 }
          
        guard length > 0 else { return .infinity }

        return Double(amount) / Double(length)
      }
    }
    
    Scope(state: \.trends, action: /Action.trends) {
      Trender { parameters, amounts in
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
    }
    
    Scope(state: \.breaks, action: /Action.breaks) {
      Breaker { date, entries in
        entries
          .last { $0 < date }
          .flatMap { DateInterval(start: $0, safeEnd: date) }.optional?
          .duration
          ?? .infinity
      }
    }
    
    Scope(state: \.longestBreaks, action: /Action.longestBreaks) {
      LongestBreaker { until, entries in
        guard let first = entries.first else { return .infinity }
        
        if entries.count == 1 { return first.distance(to: until) }
        
        return entries.reduce((previousDate: first, longestInterval: TimeInterval.zero)) { result, date in
          (
            previousDate: date,
            longestInterval: max(result.longestInterval, date.timeIntervalSince(result.previousDate))
          )
        }.longestInterval
      }
    }
    
    Scope(state: \.averageBreaks, action: /Action.averageBreaks) {
      AverageBreaker { interval, amounts in
        guard
          let amount = amounts[interval],
          amount > 1
        else { return .infinity }
        
        return interval.dateInterval.duration / Double(amount)
      }
    }
    
    Reduce<State, Action> { state, action in
      switch action {
      case let .filter(interval):
        return .send(.filtereds(.calculate(interval)))
        
      case let .amount(interval):
        return .send(.amounts(.calculate(interval)))
        
      case let .allAmounts(interval, subdivision):
        return .run { send in
          if let intervals = interval.enumerate(by: subdivision) {
            for interval in intervals { await send(.amounts(.calculate(interval))) }
          }
        }
        
      case let .average(interval, subdivision):
        return .run { send in
          await send(.amount(interval))
          await send(.averages(.calculate(.init(interval, subdivision))))
        }
        
      case let .trend(interval, subdivision):
        return .run { send in
          await send(.allAmounts(interval, subdivision))
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
         amount(Interval),
         allAmounts(Interval, Subdivision)
    
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
