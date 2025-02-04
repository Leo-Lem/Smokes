// Created by Leopold Lemmermann on 04.02.25.

import Bundle
import Calculate
import ComposableArchitecture
import Extensions
import Foundation
import Types

@Reducer
public struct History: Sendable {
  @ObservableState
  public struct State: Equatable {
    @Shared(.fileStorage(FileManager.document_url(
      Dependency(\.bundle).wrappedValue.string("ENTRIES_FILENAME")
    )))
    public var entries = Dates()

    @Shared(.appStorage("history_option")) var option = HistoryOption.week
    var selection = Dependency(\.date.now).wrappedValue - 86400
    var editing = false

    public init() {}
  }

  public enum Action: Sendable {
    case startEditing,
         stopEditing,
         add,
         remove,
         changeOption(HistoryOption),
         changeSelection(Date)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .startEditing: state.editing = true
      case .stopEditing: state.editing = false

      case .add:
        state.$entries.withLock {
          $0.insert(state.selection, at: state.entries.firstIndex { state.selection < $0 } ?? state.entries.endIndex)
        }
      case .remove:
        if
          let nearest = state.entries
            .min(by: { abs($0.distance(to: state.selection)) < abs($1.distance(to: state.selection)) }),
          cal.isDate(nearest, inSameDayAs: state.selection) {
            state.$entries.withLock {
              _ = $0.remove(at: state.entries.firstIndex(of: nearest)!)
            }
        }

      case let .changeOption(option): state.$option.withLock { $0 = option }
      case let .changeSelection(selection): state.selection = selection
      }

      return .none
    }
  }

  @Dependency(\.calendar) var cal

  public init() {}
}

public extension History.State {
  var interval: Interval { option.interval(selection) }
  var subdivision: Subdivision { option.subdivision }

  var dayAmount: Int {
    @Dependency(\.calculate) var calculate
    return calculate.amount(.day(selection), entries.array)
  }
  var untilHereAmount: Int? {
    @Dependency(\.calculate) var calculate
    @Dependency(\.calendar) var cal
    return calculate.amount(.to(cal.endOfDay(for: selection)), entries.array)
  }
  var optionAmount: Int {
    @Dependency(\.calculate) var calculate
    return calculate.amount(interval, entries.array)
  }
  var plotData: [Interval: Int]? {
    @Dependency(\.calculate) var calculate
    return calculate.amounts(interval, subdivision, entries.array)
  }

  var bounds: Interval {
    @Dependency(\.calendar) var cal
    @Dependency(\.date.now) var now
    return Interval.to(cal.endOfDay(for: now))
  }
}
