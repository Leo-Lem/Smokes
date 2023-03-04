import ComposableArchitecture
import SwiftUI

struct StatsView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store, observe: ViewState.init, send: ViewAction.send) { viewStore in
      VStack {
        AmountWidget(viewStore.daily, description: "per day")

        HStack {
          AmountWidget(viewStore.weekly, description: "per week")
          AmountWidget(viewStore.monthly, description: "per month")
        }
      }
      .padding()
      .onAppear { viewStore.send(.calculate) }
    }
  }
}

extension StatsView {
  struct ViewState: Equatable {
    let daily: Double?, weekly: Double?, monthly: Double?

    init(_ state: MainReducer.State) {
      @Dependency(\.date.now) var now: Date
      @Dependency(\.calendar) var cal: Calendar
      let date = cal.startOfDay(for: now + 86400)

      daily = state.average(until: date, by: .day)
      weekly = state.average(until: date, by: .weekOfYear)
      monthly = state.average(until: date, by: .month)
    }
  }

  enum ViewAction: Equatable {
    case calculate

    static func send(_ action: Self) -> MainReducer.Action {
      @Dependency(\.date.now) var now: Date
      @Dependency(\.calendar) var cal: Calendar

      return .calculateAmountForAverageUntil(cal.startOfDay(for: now + 86400))
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct AveragesView_Previews: PreviewProvider {
  static var previews: some View {
    StatsView()
      .environmentObject(Store(initialState: .preview, reducer: MainReducer()))
  }
}
#endif
