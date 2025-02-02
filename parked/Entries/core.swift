// Created by Leopold Lemmermann on 28.04.23.

import ComposableArchitecture
import struct Foundation.Date
import struct Foundation.Calendar

public struct Entries: Reducer {
  public enum Action {
    case set([Date]),
         add(Date),
         remove(Date)
  }

  public var body: some Reducer<Dates, Action> {
    Reduce { state, action in
      switch action {
      case let .set(entries):
        state.array = entries

      case let .add(date):
        state.insert(date, at: state.firstIndex { date < $0 } ?? state.endIndex)

      case let .remove(date):
        @Dependency(\.calendar) var cal: Calendar
        if
          let nearest = state.min(by: { abs($0.distance(to: date)) < abs($1.distance(to: date)) }),
          cal.isDate(nearest, inSameDayAs: date)
        {
          state.remove(at: state.firstIndex(of: nearest)!)
        }
      }

      return .none
    }
  }
}
