// Created by Leopold Lemmermann on 02.02.25.

import Bundle
import Calculate
import ComposableArchitecture
import Extensions
import Foundation
import Types

@Reducer public struct Dashboard: Sendable {
  @ObservableState public struct State: Equatable {
    @Shared public var transferring: Bool
    @Shared public var entries: Dates
    @Shared var amountOption: AmountOption
    @Shared var timeOption: TimeOption

    public init(
      transferring: Shared<Bool> = Shared(value: false),
      entries: Dates = Dates(),
      amountOption: AmountOption = .week,
      timeOption: TimeOption = .sinceLast
    ) {
      _transferring = transferring
      _entries = Shared(wrappedValue: entries, .fileStorage(.documentsDirectory.appending(path: "entries.json")))
      _amountOption = Shared(wrappedValue: amountOption, .appStorage("dashboard_amountOption"))
      _timeOption = Shared(wrappedValue: timeOption, .appStorage("dashbaord_timeOption"))
    }
  }

  public enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case addButtonTapped
    case removeButtonTapped
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        state.$entries.withLock {
          $0.insert(now, at: state.entries.firstIndex { now < $0 } ?? state.entries.endIndex)
        }
        
      case .removeButtonTapped:
        if
          let nearest = state.entries.min(by: { abs($0.distance(to: now)) < abs($1.distance(to: now)) }),
          cal.isDate(nearest, inSameDayAs: now) {
          state.$entries.withLock {
            _ = $0.remove(at: state.entries.firstIndex(of: nearest)!)
          }
        }

      case .binding: break
      }
      return .none
    }
  }

  @Dependency(\.date.now) var now
  @Dependency(\.calendar) var cal

  public init() {}
}

public extension Dashboard.State {
  var dayAmount: Int {
    @Dependency(\.calculate.amount) var amount
    @Dependency(\.date.now) var now
    return amount(.day(now), entries.array)
  }

  var untilHereAmount: Int {
    @Dependency(\.calculate.amount) var amount
    @Dependency(\.date.now) var now
    @Dependency(\.calendar) var cal
    return amount(.to(cal.endOfDay(for: now)), entries.array)
  }

  var optionAmount: Int {
    @Dependency(\.calculate.amount) var amount
    return amount(amountOption.interval, entries.array)
  }

  // TODO: refresh
  var optionTime: TimeInterval {
    @Dependency(\.calculate) var calculate
    @Dependency(\.date.now) var now
    return switch timeOption {
    case .sinceLast: calculate.break(now, entries.array)
    case .longestBreak: calculate.longestBreak(now, entries.array)
    }
  }
}
