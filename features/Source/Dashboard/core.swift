// Created by Leopold Lemmermann on 02.02.25.

import Calculate
import ComposableArchitecture
import Extensions
import Foundation
import Types

@Reducer
public struct Dashboard: Sendable {
  @ObservableState
  public struct State: Equatable {
    @Shared(.fileStorage(FileManager.document_url(Bundle.main[string: "ENTRIES_FILENAME"])))
    public var entries = Dates()
    @Shared(.appStorage("dashboard_amountOption")) var amountOption = AmountOption.week
    @Shared(.appStorage("dashboard_timeOption")) var timeOption = TimeOption.sinceLast

    var dayAmount: Int?
    var untilHereAmount: Int?
    var optionAmount: Int?
    var optionTime: TimeInterval?
  }

  public enum Action: Sendable {
    case add,
         remove,
         changeAmountOption(AmountOption),
         changeTimeOption(TimeOption),
         update
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .add:
        state.$entries.withLock {
          $0.insert(now, at: state.entries.firstIndex { now < $0 } ?? state.entries.endIndex)
        }
        return .send(.update)

      case .remove:
        if
          let nearest = state.entries.min(by: { abs($0.distance(to: now)) < abs($1.distance(to: now)) }),
          cal.isDate(nearest, inSameDayAs: now) {
            state.$entries.withLock {
              _ = $0.remove(at: state.entries.firstIndex(of: nearest)!)
            }
        }
        return .send(.update)

      case let .changeAmountOption(option):
        state.optionAmount = calculate.amount(option.interval, state.entries.array)

      case let .changeTimeOption(option):
        state.optionTime = switch option {
          case .sinceLast: calculate.break(now, state.entries.array)
          case .longestBreak: calculate.longestBreak(now, state.entries.array)
          }

      case .update:
        state.dayAmount = calculate.amount(.day(now), state.entries.array)
        state.untilHereAmount = calculate.amount(.to(cal.endOfDay(for: now)), state.entries.array)
        return .concatenate(
          .send(.changeAmountOption(state.amountOption)),
          .send(.changeTimeOption(state.timeOption))
        )
      }

      return .none
    }
  }

  @Dependency(\.date.now) var now
  @Dependency(\.calendar) var cal
  @Dependency(\.calculate) var calculate

  public init() {}
}
