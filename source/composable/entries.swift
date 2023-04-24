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
      return .run { actions in
        if let loaded = try await persistor.readDates() { await actions.send(.set(loaded)) }
        await actions.send(.setAreLoaded)
      } catch: { error, actions in
        debugPrint(error)
        await actions.send(.setAreLoaded)
      }
      
    case .save:
      let entries = state.entries
      return .fireAndForget {
        do { try await persistor.writeDates(entries) } catch { debugPrint(error) }
      }
      
    case let .add(date):
      state.entries.insert(date, at: state.entries.firstIndex { date < $0 } ?? state.entries.endIndex)
      
    case let .remove(date):
      @Dependency(\.calendar) var cal: Calendar
      let entriesInSameDay = state.entries.filter { cal.isDate($0, inSameDayAs: date) }
      
      if let index = entriesInSameDay.firstIndex(of: date) ??
        entriesInSameDay.map({ abs($0.distance(to: date)) }).enumerated().min(by: { $0.element < $1.element })?.offset
      {
        state.entries.remove(at: index)
      }
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
