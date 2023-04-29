// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture

extension HistoryView {
  enum ViewAction: Equatable {
    case add,
         remove

    static func send(_ action: Self, selection: Date) -> App.Action {
      switch action {
      case .add: return .entries(.add(selection))
      case .remove: return .entries(.remove(selection))
      }
    }
  }
}
