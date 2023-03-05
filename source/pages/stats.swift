import ComposableArchitecture
import SwiftUI

struct StatsView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store, observe: { ViewState($0, subdivision: subdivision) }, send: ViewAction.send) { viewStore in
      VStack {
        VStack {
          PlotWidget(data: viewStore.subdivided, description: nil)
          SubdivisionPickerWidget(subdivision: $subdivision, subdivisions: subdivisions)
            .padding([.horizontal, .bottom])
        }
        .widgetStyle()
        
        HStack {
          AmountWidget(viewStore.daily, description: "per day").widgetStyle()
          AmountWidget(viewStore.weekly, description: "per week").widgetStyle()
          AmountWidget(viewStore.monthly, description: "per month").widgetStyle()
        }

        // TODO: make this work
//        AmountWidget(viewStore.monthOverMonth, description: "monthly trend")
      }
      .padding()
      .animation(.default, value: viewStore.state)
      .onAppear {
        viewStore.send(.calculateAverages)
        for subdivision in subdivisions { viewStore.send(.calculateSubdivision(subdivision))}
      }
    }
  }

  @State private var subdivision = Calendar.Component.month
  private let subdivisions = [Calendar.Component.weekOfYear, .month]
}

extension StatsView {
  struct ViewState: Equatable {
    let daily: Double?, weekly: Double?, monthly: Double?
    let monthOverMonth: Double?
    let subdivided: [DateInterval: Int]

    init(_ state: MainReducer.State, subdivision: Calendar.Component) {
      @Dependency(\.date.now) var now: Date
      @Dependency(\.calendar) var cal: Calendar
      let date = cal.startOfDay(for: now + 86400)

      daily = state.average(until: date, by: .day)
      weekly = state.average(until: date, by: .weekOfYear)
      monthly = state.average(until: date, by: .month)
      monthOverMonth = state.trend(until: date, by: .month)
      subdivided = state.subdivide(until: date, by: subdivision)
    }
  }

  enum ViewAction: Equatable {
    case calculateAverages, calculateSubdivision(Calendar.Component)

    static func send(_ action: Self) -> MainReducer.Action {
      @Dependency(\.date.now) var now: Date
      @Dependency(\.calendar) var cal: Calendar
      let date = cal.startOfDay(for: now + 86400)

      switch action {
      case .calculateAverages: return .calculateAmountUntil(date)
      case let .calculateSubdivision(subdivision): return .calculateAmountsUntil(date, subdivision)
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
