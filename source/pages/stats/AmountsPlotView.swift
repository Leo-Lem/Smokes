// Created by Leopold Lemmermann on 12.03.23.

import ComposableArchitecture
import SwiftUI

struct AmountsPlotView: View {
  let interval: DateInterval?
  let subdivision: Calendar.Component

  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store) {
      ViewState($0, interval: interval, subdivision: subdivision)
    } send: {
      ViewAction.send($0)
    } content: { viewStore in
      Widget {
        DatedAmountsPlot(data: viewStore.subdivided, description: nil)
      }
      .animation(.default, value: viewStore.state)
      .onAppear { viewStore.send(.calculateSubdivision(nil, subdivision)) }
      .onChange(of: interval) { viewStore.send(.calculateSubdivision($0, subdivision)) }
    }
  }
}

extension AmountsPlotView {
  struct ViewState: Equatable {
    let subdivided: [DateInterval: Int]

    init(_ state: MainReducer.State, interval: DateInterval?, subdivision: Calendar.Component) {
      @Dependency(\.calendar) var cal: Calendar
      let tomorrow = cal.startOfDay(for: Dependency(\.date.now).wrappedValue + 86400)

      var subdivisionInterval: DateInterval {
        switch interval {
        case .none:
          return DateInterval(start: state.startDate, end: tomorrow)
        case let .some(interval) where interval.end >= tomorrow:
          return DateInterval(start: interval.start, end: tomorrow)
        case let .some(interval):
          return interval
        }
      }
      
      subdivided = state.subdivide(subdivisionInterval, by: subdivision) ?? [:]
    }
  }

  enum ViewAction: Equatable {
    case calculateSubdivision(DateInterval?, Calendar.Component)

    static func send(_ action: Self) -> MainReducer.Action {
      @Dependency(\.calendar) var cal: Calendar
      let tomorrow = cal.startOfDay(for: Dependency(\.date.now).wrappedValue + 86400)

      switch action {
      case let .calculateSubdivision(interval, subdivision):
        switch interval {
        case .none:
          return .calculateAmountsUntil(tomorrow, subdivision)
        case let .some(interval) where interval.end >= tomorrow:
          return .calculateAmounts(DateInterval(start: interval.start, end: tomorrow), subdivision)
        case let .some(interval):
          return .calculateAmounts(interval, subdivision)
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

struct AmountsPlotWidget_Previews: PreviewProvider {
  static var previews: some View {
    AmountsPlotView(interval: nil, subdivision: .month)
      .environmentObject(StoreOf<MainReducer>(initialState: .preview, reducer: MainReducer()))
      .padding()
  }
}
