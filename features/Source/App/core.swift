// Created by Leopold Lemmermann on 02.02.25.

import ComposableArchitecture
import Dashboard
import Fact
import History
import Info
import Statistic
import Transfer

// TODO: reactivate animations

@Reducer
public struct Smokes: Sendable {
  @ObservableState
  public struct State: Equatable {
    var dashboard: Dashboard.State
    var history = History.State()
    var statistic = Statistic.State()

    @Presents var fact: Fact.State?
    @Presents var info: Info.State?
    @Presents var transfer: Transfer.State?

    @Shared var transferring: Bool

    var tab = Tab.dashboard

    public enum Tab: Sendable {
      case history, dashboard, statistic
    }

    public init() {
      _transferring = Shared(value: false)
      dashboard = Dashboard.State(transferring: _transferring)
    }
  }

  public enum Action: Sendable {
    case dashboard(Dashboard.Action),
         history(History.Action),
         statistic(Statistic.Action),
         fact(PresentationAction<Fact.Action>),
         info(PresentationAction<Info.Action>),
         transfer(PresentationAction<Transfer.Action>),
         infoButtonTapped,
         factButtonTapped,
         selectTab(State.Tab)
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.dashboard, action: \.dashboard, child: Dashboard.init)
      .onChange(of: \.transferring) { _, new in
        Reduce { state, _ in
          state.transfer = new ? Transfer.State() : nil
          return .none
        }
      }
    Scope(state: \.history, action: \.history, child: History.init)
    Scope(state: \.statistic, action: \.statistic, child: Statistic.init)
    Reduce { state, action in
      switch action {
      case let .selectTab(tab):
        state.tab = tab
      case .factButtonTapped:
        state.fact = Fact.State()
      case .infoButtonTapped:
        state.info = Info.State()
      default: break
      }

      return .none
    }
    .ifLet(\.$fact, action: \.fact) { Fact() }
    .ifLet(\.$info, action: \.info) { Info() }
    .ifLet(\.$transfer, action: \.transfer) { Transfer() }
  }

  public init() {}
}
