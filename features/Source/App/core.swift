// Created by Leopold Lemmermann on 02.02.25.

import ComposableArchitecture
import Dashboard
import Fact

@Reducer
public struct Smokes: Sendable {
  @ObservableState
  public struct State: Equatable {
    @Presents var dashboard: Dashboard.State?
    @Presents var fact: Fact.State?

    var tab = Tab.dashboard

    public init() {}
  }

  public enum Action: Sendable {
    case dashboard(PresentationAction<Dashboard.Action>),
         fact(PresentationAction<Fact.Action>),
         factButtonTapped,
         selectTab(Tab)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .selectTab(tab):
        state.tab = tab
      case .factButtonTapped:
        state.fact = Fact.State()
      default:
        break
      }

      return .none
    }
    .ifLet(\.$dashboard, action: \.dashboard) { Dashboard() }
    .ifLet(\.$fact, action: \.fact) { Fact() }
  }

  public init() {}
}
