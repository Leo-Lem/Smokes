import ComposableArchitecture
import SwiftUI

struct DashboardView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store, observe: ViewState.init, send: ViewAction.send) { viewStore in
      GeometryReader { geo in
        VStack {
          Widget {
            AmountWithLabel(viewStore.day, description: "today")
              .attachPlot {
                if let subdivided = viewStore.subdividedMonth {
                  DatedAmountsPlot(data: subdivided, description: nil)
                } else {
                  ProgressView()
                }
              }
              .frame(height: geo.size.height / 3)
              .onAppear {
                viewStore.send(.calculateDay)
                viewStore.send(.calculateSubdividedMonth)
              }
          }

          Widget { AmountWithLabel(viewStore.before, description: "yesterday") }
            .onAppear { viewStore.send(.calculateBefore) }

          HStack {
            Widget { AmountWithLabel(viewStore.week, description: "week") }
              .onAppear { viewStore.send(.calculateWeek) }
            Widget { AmountWithLabel(viewStore.month, description: "month") }
              .onAppear { viewStore.send(.calculateMonth) }
            Widget { AmountWithLabel(viewStore.year, description: "year") }
              .onAppear { viewStore.send(.calculateYear) }
          }

          HStack {
            Widget {
              AmountWithLabel(viewStore.all, description: "until now")
                .attachPorter()
            }
            .onAppear { viewStore.send(.calculateAll) }

            Widget {
              IncrementMenu(decrementDisabled: viewStore.day ?? 0 < 1) {
                viewStore.send(.add)
              } remove: {
                viewStore.send(.remove)
              }
            }
          }
        }
      }
      .animation(.default, value: viewStore.state)
    }
  }
}

extension DashboardView {
  struct ViewState: Equatable {
    let day: Int?, before: Int?, week: Int?, month: Int?, year: Int?
    let all: Int?
    let subdividedMonth: [DateInterval: Int]?

    init(_ state: MainReducer.State) {
      @Dependency(\.calendar) var cal: Calendar
      @Dependency(\.date.now) var now: Date

      day = state.amounts[cal.dateInterval(of: .day, for: now)!]
      before = state.amounts[cal.dateInterval(of: .day, for: now - 86400)!]
      week = state.amounts[cal.dateInterval(of: .weekOfYear, for: now)!]
      month = state.amounts[cal.dateInterval(of: .month, for: now)!]
      year = state.amounts[cal.dateInterval(of: .year, for: now)!]

      let tomorrow = cal.startOfDay(for: now + 86400)

      all = state.amounts[DateInterval(start: .distantPast, end: tomorrow)]

      let interval = DateInterval(start: cal.dateInterval(of: .month, for: now)!.start, end: tomorrow)
      subdividedMonth = state.subdivide(interval, by: .day)
    }
  }

  enum ViewAction: Equatable {
    case add, remove
    case calculateDay, calculateBefore, calculateWeek, calculateMonth, calculateYear
    case calculateAll
    case calculateSubdividedMonth

    static func send(_ action: Self) -> MainReducer.Action {
      @Dependency(\.calendar) var cal: Calendar
      @Dependency(\.date.now) var now: Date

      switch action {
      case .add: return .add(now)
      case .remove: return .remove(now)
      case .calculateDay: return .calculateAmount(cal.dateInterval(of: .day, for: now)!)
      case .calculateBefore: return .calculateAmount(cal.dateInterval(of: .day, for: now - 86400)!)
      case .calculateWeek: return .calculateAmount(cal.dateInterval(of: .weekOfYear, for: now)!)
      case .calculateMonth: return .calculateAmount(cal.dateInterval(of: .month, for: now)!)
      case .calculateYear: return .calculateAmount(cal.dateInterval(of: .year, for: now)!)
      case .calculateAll:
        return .calculateAmount(DateInterval(start: .distantPast, end: cal.startOfDay(for: now + 86400)))
      case .calculateSubdividedMonth:
        return .calculateAmounts(cal.dateInterval(of: .month, for: now)!, .day)
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct DashboardView_Previews: PreviewProvider {
  static var previews: some View {
    DashboardView()
      .environmentObject(StoreOf<MainReducer>(initialState: .preview, reducer: MainReducer()))
      .padding()
  }
}
#endif
