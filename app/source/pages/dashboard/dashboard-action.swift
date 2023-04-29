// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import Foundation

extension DashboardView {
  enum ViewAction {
    case add,
         remove
    
    case calculateDay,
         calculateUntilNow,
         calculateOption(AmountOption)
    
    static func send(_ action: Self) -> App.Action {
      @Dependency(\.calendar) var cal: Calendar
      @Dependency(\.date.now) var now: Date
      
      switch action {
      case .add: return .entries(.add(now))
      case .remove: return .entries(.remove(now))
      
      case .calculateDay: return .calculate(.amount(.day(now)))
      case .calculateUntilNow: return .calculate(.amount(.to(cal.endOfDay(for: now))))
      case let .calculateOption(option): return .calculate(.amount(option.interval))
      }
    }
    
    static func setup(_ vs: ViewStore<ViewState, ViewAction>) {
      vs.send(.calculateDay)
      vs.send(.calculateUntilNow)
      AmountOption.allCases.forEach { vs.send(.calculateOption($0)) }
    }
  }
}
