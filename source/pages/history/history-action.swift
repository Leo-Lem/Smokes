// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import Foundation

extension HistoryView {
  enum ViewAction: Equatable {
    case add(Date),
         remove(Date)
    
    case calculateDayAmount(Date),
         calculateConfiguredAmount(IntervalOption, Date),
         calculateUntilHereAmount(Date)
    
    case calculateConfiguredEntries(IntervalOption, Date)

    static func send(_ action: Self) -> MainReducer.Action {
      @Dependency(\.calendar) var cal
      
      switch action {
      case let .add(date): return .entries(.add(date))
      case let .remove(date): return .entries(.remove(date))
        
      case let .calculateDayAmount(date): return .calculateAmount(.day(date))
      case let .calculateUntilHereAmount(date): return .calculateAmount(.to(date))
      case let .calculateConfiguredAmount(option, date): return .calculateAmount(option.interval(date))
        
      case let .calculateConfiguredEntries(option, date): return .calculateFilter(option.interval(date))
      }
    }
    
    static func update(_ vs: ViewStore<ViewState, ViewAction>, selectedDate: Date) {
      vs.send(.calculateDayAmount(selectedDate))
      vs.send(.calculateUntilHereAmount(selectedDate))
      IntervalOption.allCases.forEach {
        vs.send(.calculateConfiguredAmount($0, selectedDate))
        vs.send(.calculateConfiguredEntries($0, selectedDate))
      }
    }
  }
}
