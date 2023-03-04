import ComposableArchitecture
import SwiftUI

struct StatsView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store, observe: ViewState.init, send: ViewAction.send) { viewStore in
      VStack {
        AmountWidget(viewStore.daily, description: "per day")
          .onAppear { viewStore.send(.calculateDaily) }
        
        HStack {
          AmountWidget(viewStore.weekly, description: "per week")
            .onAppear { viewStore.send(.calculateWeekly) }
          AmountWidget(viewStore.monthly, description: "per month")
            .onAppear { viewStore.send(.calculateMonthly) }
        }
      }
      .padding()
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
    case calculateDaily, calculateWeekly, calculateMonthly

    static func send(_ action: Self) -> MainReducer.Action {
      @Dependency(\.date.now) var now: Date
      @Dependency(\.calendar) var cal: Calendar
      let date = cal.startOfDay(for: now + 86400)
      
      switch action {
      case .calculateDaily: return .calculateAverageUntil(date, .day)
      case .calculateWeekly: return .calculateAverageUntil(date, .weekOfYear)
      case .calculateMonthly: return .calculateAverageUntil(date, .month)
      }
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
