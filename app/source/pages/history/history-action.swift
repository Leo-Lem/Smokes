// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture

extension HistoryView {
  enum ViewAction: Equatable {
    case add,
         remove
    
    case calculateDayAmount,
         calculateAmount(Option),
         calculateUntilHereAmount
    
    case calculatePlotData(Option)

    static func send(_ action: Self, selection: Date) -> App.Action {
      @Dependency(\.calendar) var cal
      
      switch action {
      case .add: return .entries(.add(selection))
      case .remove: return .entries(.remove(selection))
        
      case .calculateDayAmount: return .calculate(.amount(.day(selection)))
      case .calculateUntilHereAmount: return .calculate(.amount(.to(selection)))
      case let .calculateAmount(option): return .calculate(.amount(option.interval(selection)))
        
      case let .calculatePlotData(option):
        return .calculate(.filterAmounts(option.interval(selection), option.subdivision))
      }
    }
    
    static func update(_ vs: ViewStore<ViewState, ViewAction>, option: Option) {
      vs.send(.calculateDayAmount)
      vs.send(.calculateUntilHereAmount)
      vs.send(.calculateAmount(option))
      vs.send(.calculatePlotData(option))
    }
  }
}
