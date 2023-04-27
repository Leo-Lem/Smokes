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
      
      case .calculateDay: return .calculateAmount(.day(now))
      case .calculateUntilNow: return .calculateAmount(.to(.endOfToday))
      case let .calculateOption(option): return .calculateAmount(option.interval)
      
        // FIXME: make breaks use a reliable parameter
      case .calculateBreak: return .calculateBreak(.today)
      case .calculateLongestBreak: return .calculateLongestBreak(.today)
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
