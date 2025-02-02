// Created by Leopold Lemmermann on 02.02.25.

import ComposableArchitecture
import Dashboard

@Reducer public enum Smokes {
  case dashboard(Dashboard)

  public static var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .dashboard:
        return .none
      }
    }
//    .ifCaseLet(.dashboard, action: \.dashboard)
  }
}
extension Smokes.State: Equatable {}
