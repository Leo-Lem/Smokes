// Created by Leopold Lemmermann on 26.03.23.

import ComposableArchitecture
import Foundation

struct Entries: ReducerProtocol {
  @Dependency(\.persistor) private var persistor
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .setAreLoaded:
      state.areLoaded = true
      
    case let .set(entries):
      state.entries = entries
      
    case .load:
      return .run { send in
        if let loaded = try await persistor.readDates() { await send(.set(loaded)) }
        await send(.setAreLoaded)
      } catch: { error, send in
        debugPrint(error)
        await send(.setAreLoaded)
      }
      
    case .save:
      let entries = state.entries
      return .fireAndForget {
        do { try await persistor.writeDates(entries) } catch { debugPrint(error) }
      }
      
    case let .add(date):
      var entries = state.entries
      entries.insert(date, at: state.entries.firstIndex { date < $0 } ?? state.entries.endIndex)
      return .send(.set(entries))
      
      // FIXME: removing has no effect
    case let .remove(date):
      @Dependency(\.calendar) var cal: Calendar
      var entries = state.entries
      let entriesInSameDay = entries.filter { cal.isDate($0, inSameDayAs: date) }
      
      if let index = entriesInSameDay.firstIndex(of: date) ??
        entriesInSameDay.map({ abs($0.distance(to: date)) }).enumerated().min(by: { $0.element < $1.element })?.offset
      {
        entries.remove(at: index)
      }
      
      return .send(.set(entries))
    }
    
    return .none
  }
}

extension Entries {
  struct State: Equatable {
    var entries = [Date]()
    
    var areLoaded = false
    
    var startDate: Date {
      @Dependency(\.calendar) var cal: Calendar
      @Dependency(\.date.now) var now: Date
      
      return cal.startOfDay(for: entries.first ?? now)
    }
  }
}

extension Entries {
  enum Action {
    case set(_ entries: [Date]), setAreLoaded
    case load, save
    case add(_ date: Date), remove(_ date: Date)
  }
}
