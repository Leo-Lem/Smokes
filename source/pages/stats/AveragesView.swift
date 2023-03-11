// Created by Leopold Lemmermann on 12.03.23.

import ComposableArchitecture
import SwiftUI

struct AveragesView: View {
  let interval: DateInterval?

  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store) {
      ViewState($0, month: interval)
    } send: {
      ViewAction.send($0)
    } content: { viewStore in
      HStack {
        Widget { AmountWithLabel(viewStore.averages[.day]?.optional, description: "per day") }
        Widget { AmountWithLabel(viewStore.averages[.weekOfYear]?.optional, description: "per week") }
        Widget { AmountWithLabel(viewStore.averages[.month]?.optional, description: "per month") }
      }
      .onAppear { viewStore.send(.calculateAverages(interval)) }
      .onChange(of: interval) { viewStore.send(.calculateAverages($0)) }
      .animation(.default, value: viewStore.state)
    }
  }
}

extension AveragesView {
  struct ViewState: Equatable {
    let averages: [Calendar.Component: Double?]

    init(_ state: MainReducer.State, month: DateInterval?) {
      @Dependency(\.date.now) var now: Date
      @Dependency(\.calendar) var cal: Calendar
      let tomorrow = cal.startOfDay(for: now + 86400)

      let comps = [Calendar.Component.day, .weekOfYear, .month]

      var interval: DateInterval {
        switch month {
        case .none:
          return DateInterval(start: state.startDate, end: tomorrow)
        case let .some(month) where month.end >= tomorrow:
          return DateInterval(start: month.start, end: tomorrow)
        case let .some(month):
          return month
        }
      }

      averages = Dictionary(uniqueKeysWithValues: comps.map { ($0, state.average(interval, by: $0)) })
    }
  }

  enum ViewAction: Equatable {
    case calculateAverages(_ month: DateInterval?)

    static func send(_ action: Self) -> MainReducer.Action {
      @Dependency(\.date.now) var now: Date
      @Dependency(\.calendar) var cal: Calendar
      let tomorrow = cal.startOfDay(for: now + 86400)

      switch action {
      case let .calculateAverages(month):
        switch month {
        case .none:
          return .calculateAmountUntil(tomorrow)
        case let .some(month) where month.end >= tomorrow:
          return .calculateAmount(.init(start: month.start, end: tomorrow))
        case let .some(month):
          return .calculateAmount(month)
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

struct AveragesWidget_Previews: PreviewProvider {
  static var previews: some View {
    AveragesView(interval: nil)
      .environmentObject(StoreOf<MainReducer>(initialState: .preview, reducer: MainReducer()))
      .padding()
  }
}
