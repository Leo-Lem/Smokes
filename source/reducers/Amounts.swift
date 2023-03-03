// Created by Leopold Lemmermann on 03.03.23.

import ComposableArchitecture
import Foundation

struct Amounts: ReducerProtocol {
  struct State: Equatable {
    var cache = [DateInterval: Int]() {
      didSet { print(cache) }
    }
    
    subscript(_ interval: DateInterval) -> Int? {
      get { cache[interval] }
      set { cache[interval] = newValue }
    }
    
    subscript(until date: Date, startDate: Date) -> Int? {
      get { DateInterval(start: startDate, safeEnd: date).flatMap { cache[$0] } ?? 0 }
      set { DateInterval(start: startDate, safeEnd: date).flatMap { cache[$0] = newValue } }
    }
  }
  
  enum Action {
    case calculate(_ interval: DateInterval, _ entries: [Date])
    case calculateUntil(Date, _ startDate: Date, _ entries: [Date])
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .calculate(interval, entries):
      state.cache[interval] = entries.filter { interval.start <= $0 && $0 < interval.end }.count
      
      // FIXME: the dates need to be normalized (start of day, example), otherwise entries wont be captured
    case let .calculateUntil(date, startDate, entries):
      return .send(.calculate(DateInterval(start: startDate, safeEnd: date) ?? .init(), entries))
    }
    
    return .none
  }
}

extension DateInterval {
  init?(start: Date, safeEnd: Date) {
    if start <= safeEnd { self.init(start: start, end: safeEnd) } else { return nil }
  }
}
