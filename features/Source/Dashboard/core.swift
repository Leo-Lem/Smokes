// Created by Leopold Lemmermann on 02.02.25.

import ComposableArchitecture
import Foundation
import Types

// TODO: move this somewhere else
let url = try! FileManager.default
  .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
  .appending(component: "entries.json")
  .appendingPathExtension(for: .json)

@Reducer
public struct Dashboard: Sendable {
  @ObservableState
  public struct State: Equatable {
    @Shared(.fileStorage(url)) public var entries = Dates()
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
         port,
         changeAmountOption(AmountOption),
         changeTimeOption(TimeOption)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      return .none
    }
  }
}
