// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import Foundation

extension DashboardView {
  enum ViewAction {
    case add,
         remove
    
    static func send(_ action: Self) -> App.Action {
      @Dependency(\.date.now) var now: Date
      
      switch action {
      case .add: return .entries(.add(now))
      case .remove: return .entries(.remove(now))
      }
    }
  }
}
