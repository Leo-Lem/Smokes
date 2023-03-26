// Created by Leopold Lemmermann on 26.03.23.

import ComposableArchitecture
import Foundation

struct Entries: ReducerProtocol {
  @Dependency(\.persistor) private var persistor
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .set(entries):
      state.unwrapped = entries
      return .send(.updateAmounts())
      
    case .load:
      return .task {
        .set(try await persistor.readDates() ?? [])
      } catch: { error in
        debugPrint(error)
        return .set([])
      }
      
    case .save:
      let entries = state.unwrapped
      return .fireAndForget {
        do { try await persistor.writeDates(entries) } catch { debugPrint(error) }
      }
      
    case let .add(date):
      state.unwrapped.insert(date, at: state.unwrapped.firstIndex { date < $0 } ?? state.unwrapped.endIndex)
      return .send(.updateAmounts(date))
      
    case let .remove(date):
      if let index = state.unwrapped.lastIndex(where: { $0 <= date }) {
        state.unwrapped.remove(at: index)
        return .send(.updateAmounts(date))
      }
      
    default:
      break
    }
    
    return .none
  }
}

extension Entries {
  struct State: Equatable {
    private var value: [Date]?
    
    var unwrapped: [Date] {
      get { value ?? [] }
      set { value = newValue }
    }

    var areLoaded: Bool { value != nil }
    var startDate: Date {
      @Dependency(\.calendar) var cal: Calendar
      @Dependency(\.date.now) var now: Date
      
      return value?.first ?? cal.startOfDay(for: now)
    }
  }
}

extension Entries {
  enum Action {
    case set(_ entries: [Date])
    case load, save
    case add(_ date: Date), remove(_ date: Date)
    case updateAmounts(_ date: Date? = nil)
  }
}
