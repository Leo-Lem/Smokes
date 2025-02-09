// Created by Leopold Lemmermann on 02.02.25.

import ComposableArchitecture
import Dashboard
import Fact
import History
import Info
import Statistic
import Transfer

// TODO: reactivate animations

@Reducer public struct Smokes: Sendable {
  @ObservableState public struct State: Equatable {
    @Shared var transferring: Bool

    var dashboard: Dashboard.State
    var history: History.State
    var statistic: Statistic.State

    @Presents var fact: Fact.State?
    @Presents var info: Info.State?
    @Presents var transfer: Transfer.State?

    var tab: Int

    public init(
      transferring: Shared<Bool> = Shared(value: false),
      dashboard: Dashboard.State? = nil,
      history: History.State = History.State(),
      statistic: Statistic.State = Statistic.State(),
      fact: Fact.State? = nil,
      info: Info.State? = nil,
      transfer: Transfer.State? = nil,
      tab: Int = 1
    ) {
      _transferring = transferring
      self.dashboard = Dashboard.State(transferring: _transferring)
      self.history = history
      self.statistic = statistic
      _fact = .init(wrappedValue: fact)
      _info = .init(wrappedValue: info)
      _transfer = .init(wrappedValue: transfer)
      self.tab = tab
    }
  }

  public enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)

    case dashboard(Dashboard.Action),
         history(History.Action),
         statistic(Statistic.Action),
         fact(PresentationAction<Fact.Action>),
         info(PresentationAction<Info.Action>),
         transfer(PresentationAction<Transfer.Action>)

    case infoButtonTapped
    case factButtonTapped
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

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
