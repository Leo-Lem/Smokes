// Created by Leopold Lemmermann on 02.02.25.

import Calculate
import ComposableArchitecture
import Extensions
import Foundation
import Types
import Bundle

@Reducer
public struct Dashboard: Sendable {
  @ObservableState
  public struct State: Equatable {
    @Shared(.fileStorage(FileManager.document_url(
      Dependency(\.bundle).wrappedValue.string("ENTRIES_FILENAME")
    )))
    public var entries = Dates()

    @Shared var porting: Bool

    @Shared(.appStorage("dashboard_amountOption")) var amountOption = AmountOption.week
    @Shared(.appStorage("dashboard_timeOption")) var timeOption = TimeOption.sinceLast

    public init() {
      _porting = Shared(value: false)
    }
  }

  public enum Action: Sendable {
    case add,
         remove,
         changeAmountOption(AmountOption),
         changeTimeOption(TimeOption),
         port
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .add:
        state.$entries.withLock {
          $0.insert(now, at: state.entries.firstIndex { now < $0 } ?? state.entries.endIndex)
        }
      case .remove:
        if
          let nearest = state.entries.min(by: { abs($0.distance(to: now)) < abs($1.distance(to: now)) }),
          cal.isDate(nearest, inSameDayAs: now) {
          state.$entries.withLock {
            _ = $0.remove(at: state.entries.firstIndex(of: nearest)!)
          }
        }
      case let .changeAmountOption(option):
        state.$amountOption.withLock { $0 = option }
      case let .changeTimeOption(option):
        state.$timeOption.withLock { $0 = option }
      case .port:
        state.$porting.withLock { $0 = true }
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
    @Dependency(\.calculate) var calculate
    @Dependency(\.date.now) var now
    return calculate.amount(.day(now), entries.array)
  }

  var untilHereAmount: Int {
    @Dependency(\.calculate) var calculate
    @Dependency(\.date.now) var now
    @Dependency(\.calendar) var cal
    return calculate.amount(.to(cal.endOfDay(for: now)), entries.array)
  }

  var optionAmount: Int {
    @Dependency(\.calculate) var calculate
    return calculate.amount(amountOption.interval, entries.array)
  }

  var optionTime: TimeInterval {
    @Dependency(\.calculate) var calculate
    @Dependency(\.date.now) var now
    return switch timeOption {
    case .sinceLast: calculate.break(now, entries.array)
    case .longestBreak: calculate.longestBreak(now, entries.array)
    }
  }
}
