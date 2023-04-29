// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture

extension HistoryView {
  enum ViewAction: Equatable {
    case add(Date),
         remove(Date)
    
    case calculateDayAmount(Date),
         calculateConfiguredAmount(Option, Date),
         calculateUntilHereAmount(Date)
    
    case calculateConfiguredEntries(Option, Date)

    static func send(_ action: Self) -> App.Action {
      @Dependency(\.calendar) var cal
      
      switch action {
      case let .add(date): return .entries(.add(date))
      case let .remove(date): return .entries(.remove(date))
        
      case let .calculateDayAmount(date): return .calculate(.amount(.day(date)))
      case let .calculateUntilHereAmount(date): return .calculate(.amount(.to(date)))
      case let .calculateConfiguredAmount(option, date): return .calculate(.amount(option.interval(date)))
        
      case let .calculateConfiguredEntries(option, date): return .calculate(.filter(option.interval(date)))
      }
    }
    
    static func update(_ vs: ViewStore<ViewState, ViewAction>, selection: Date, option: Option) {
      vs.send(.calculateDayAmount(selection))
      vs.send(.calculateUntilHereAmount(selection))
      vs.send(.calculateConfiguredAmount(option, selection))
      vs.send(.calculateConfiguredEntries(option, selection))
    }
  }
}
