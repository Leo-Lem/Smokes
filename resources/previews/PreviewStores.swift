// Created by Leopold Lemmermann on 23.02.23.

import ComposableArchitecture
import Foundation

extension StoreOf {
  static var preview: StoreOf<MainReducer> {
    .init(
      initialState: .init(
        startDate: Calendar.current.date(byAdding: .month, value: -4, to: .now)!,
        entries: Array(repeating: (), count: 500)
          .map { Date(timeIntervalSinceNow: -Double.random(in: 1 ..< 9999999)) }
      ),
      reducer: MainReducer()
    )
  }
}
