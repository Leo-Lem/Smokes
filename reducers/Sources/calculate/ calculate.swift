// Created by Leopold Lemmermann on 28.04.23.

import struct SmokesLibrary.CombinedHashable

public struct Calculate: ReducerProtocol {
  public var body: some ReducerProtocol<State, Action> {
    Scope(state: \.filtereds, action: /Action.filtereds) { Filter(filter) }
    Scope(state: \.filteredAmounts, action: /Action.filteredAmounts) { AmountsFilter(filterAmounts) }
    
    Scope(state: \.amounts, action: /Action.amounts) { Amounter(cacheLimit: 50, amount) }
    Scope(state: \.averages, action: /Action.averages) { Averager(average) }
    Scope(state: \.trends, action: /Action.trends) { Trender(trend) }
    
    Scope(state: \.averageBreaks, action: /Action.averageBreaks) { BreakAverager(averageBreak) }
    
    Reduce<State, Action> { state, action in
      let clamp = state.entries.clamp
      
      switch action {
      case let .filter(interval):
        return .send(.filtereds(.calculate(interval)))
          .cancellable(id: CombinedHashable("filter", interval), cancelInFlight: true)
        
      case let .filterAmounts(interval, subdivision):
        let parameters = IntervalAndSubdivision(interval, subdivision)
        return .run { send in
          await send(.allAmounts(parameters))
          await send(.filteredAmounts(.calculate(parameters)))
        }
        .cancellable(id: CombinedHashable("filterAmounts", parameters), cancelInFlight: true)
        
      case let .amount(interval):
        return .send(.amounts(.calculate(interval)))
          .cancellable(id: CombinedHashable("amount", interval), cancelInFlight: true)
        
      case let .average(interval, subdivision):
        let parameters = IntervalAndSubdivision(interval, subdivision)
        return .run { send in
          await send(.amount(interval))
          await send(.averages(.calculate(.init(clamp(interval), subdivision))))
        }
        .cancellable(id: CombinedHashable("average", parameters), cancelInFlight: true)
        
      case let .trend(interval, subdivision):
        let parameters = IntervalAndSubdivision(interval, subdivision)
        return .run { send in
          await send(.allAmounts(parameters))
          await send(.trends(.calculate(.init(clamp(interval), subdivision))))
        }
        .cancellable(id: CombinedHashable("trend", parameters), cancelInFlight: true)
        
      case let .averageBreak(interval):
        return .run { send in
          await send(.amount(interval))
          await send(.averageBreaks(.calculate(clamp(interval))))
        }
        .cancellable(id: CombinedHashable("averageBreak", interval), cancelInFlight: true)
        
      case let .allAmounts(parameters):
        return .run { send in
          for interval in parameters.interval.enumerate(by: parameters.subdivision) ?? [] {
            await send(.amount(interval))
          }
        }
        .cancellable(id: CombinedHashable("allAmounts", parameters), cancelInFlight: true)
        
      case let .setEntries(entries):
        state.entries = entries
        return .merge(
          .send(.filtereds(.setData(entries.array))),
          .send(.amounts(.setData(entries.array)))
        )
        .cancellable(id: CombinedHashable("setEntries", entries.array), cancelInFlight: true)
        
      case let .amounts(.setResult(amount, for: interval)):
        var amounts = state.averages.data
        amounts[clamp(interval)] = amount
        return .run { [amounts] send in
          await send(.averages(.setData(amounts)))
          await send(.trends(.setData(amounts)))
          await send(.averageBreaks(.setData(amounts)))
        }
        .cancellable(id: CombinedHashable("setAmountsData", amounts), cancelInFlight: true)
          
      default: break
      }
      
      return .none
    }
  }
}
