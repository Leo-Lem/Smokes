// Created by Leopold Lemmermann on 02.02.25.

import Components
import ComposableArchitecture
import Calculator

public struct IncrementWidget: View {
  let timestamp: Date
  let entries: StoreOf<Entries>

  public var body: some View {
    Widget {
      IncrementMenu(decrementDisabled: isZero) {
        entries.send(.add(timestamp))
      } remove: {
        entries.send(.remove(timestamp))
      }
    }
  }

  @Dependency(\.calculate) var calculate

  var isZero: Bool { calculate.amount(.day(timestamp), entries.state.array) == 0 }

  public init(timestamp: Date, entries: StoreOf<Entries>) {
    self.timestamp = timestamp
    self.entries = entries
  }
}

#Preview {
  IncrementWidget(
    timestamp: .now,
    entries: Store(initialState: Dates([.now]), reducer: Entries.init)
  )
}
