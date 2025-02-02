// Created by Leopold Lemmermann on 02.02.25.

import ComposableArchitecture
import Dashboard

@Reducer
public struct Smokes: Sendable {
  @ObservableState
  public struct State: Equatable {
    @Presents var dashboard: Dashboard.State?
    var modal: Modal? = .fact
    var tab = Tab.dashboard
  }

  public enum Action: Sendable {
    case dashboard(PresentationAction<Dashboard.Action>),
         openModal(Modal),
         closeModal,
         selectTab(Tab)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .closeModal:
        state.modal = nil
      case let .openModal(modal):
        state.modal = modal
      case let .selectTab(tab):
        state.tab = tab
      default: break
      }

      return .none
    }
    .ifLet(\.$dashboard, action: \.dashboard) { Dashboard() }
  }

  public init() {}
}
