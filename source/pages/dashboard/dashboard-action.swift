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
    
    case calculateBreak,
         calculateLongestBreak
    
    static func send(_ action: Self) -> MainReducer.Action {
      @Dependency(\.date.now) var now: Date
      
      switch action {
      case .add: return .entries(.add(now))
      case .remove: return .entries(.remove(now))
      
      case .calculateDay: return .calculate(.amount(.day(now)))
      case .calculateUntilNow: return .calculate(.amount(.to(.endOfToday)))
      case let .calculateOption(option): return .calculate(.amount(option.interval))
      
        // FIXME: make breaks use a reliable parameter
      case .calculateBreak: return .calculate(.break(.today))
      case .calculateLongestBreak: return .calculate(.longestBreak(.today))
      }
    }
    
    static func setup(_ vs: ViewStore<ViewState, ViewAction>) {
      vs.send(.calculateDay)
      vs.send(.calculateUntilNow)
      AmountOption.allCases.forEach { vs.send(.calculateOption($0)) }
      
      vs.send(.calculateBreak)
      vs.send(.calculateLongestBreak)
    }
  }
}
