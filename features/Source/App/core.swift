// Created by Leopold Lemmermann on 02.02.25.

import ComposableArchitecture
import Dashboard
import Fact
import History

public enum SmokesTab: Sendable {
  case history, dashboard, stats
}

@Reducer
public struct Smokes: Sendable {
  @ObservableState
  public struct State: Equatable {
    var dashboard = Dashboard.State()
    var history = History.State()
    @Presents var fact: Fact.State?
    var info: Bool = false

    @Shared var porting: Bool

    var tab = SmokesTab.dashboard

    public init() { _porting = Shared(value: false) }
  }

  public enum Action: Sendable {
    case dashboard(Dashboard.Action),
         history(History.Action),
         fact(PresentationAction<Fact.Action>),
         info(Bool),
         infoButtonTapped,
         factButtonTapped,
         selectTab(SmokesTab)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .selectTab(tab):
        state.tab = tab
      case .factButtonTapped:
        state.fact = Fact.State()
      case .infoButtonTapped:
        return .send(.info(true))
      case let .info(info):
        state.info = info
      default: break
      }

      return .none
    }
    .ifLet(\.$fact, action: \.fact) { Fact() }
  }

  public init() {}
}
