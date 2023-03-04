import ComposableArchitecture
import SwiftUI

struct DashboardView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store, observe: ViewState.init, send: ViewAction.send) { viewStore in
      GeometryReader { geo in
        VStack {
          AmountWidget(viewStore.day, description: "today")
            .attachPlot {
              PlotWidget(data: viewStore.subdividedMonth, description: nil)
            }
            .onAppear {
              viewStore.send(.calculateDay)
              viewStore.send(.calculateSubdividedMonth)
            }
            .frame(minHeight: geo.size.height / 3)
          
          AmountWidget(viewStore.before, description: "yesterday")
            .onAppear { viewStore.send(.calculateBefore) }
          
          HStack {
            AmountWidget(viewStore.week, description: "this week")
              .onAppear { viewStore.send(.calculateWeek) }
            AmountWidget(viewStore.month, description: "this month")
              .onAppear { viewStore.send(.calculateMonth) }
            AmountWidget(viewStore.year, description: "this year")
              .onAppear { viewStore.send(.calculateYear) }
          }
          
          HStack {
            AmountWidget(viewStore.all, description: "until now")
              .attachPorter(
                imported: viewStore.binding(get: \.entries, send: { ViewAction.addEntries($0) }),
                exported: viewStore.subdividedAll
              )
              .onAppear {
                viewStore.send(.calculateAll)
                viewStore.send(.calculateSubdividedAll)
              }
            
            IncrementWidget(decrementDisabled: viewStore.day ?? 0 < 1) {
              viewStore.send(.add)
            } remove: {
              viewStore.send(.remove)
            }
          }
        }
      }
      .padding()
      .animation(.default, value: viewStore.state)
    }
  }
}

extension DashboardView {
  struct ViewState: Equatable {
    let day: Int?, before: Int?, week: Int?, month: Int?, year: Int?
    let all: Int?
    let subdividedMonth: [DateInterval: Int], subdividedAll: [DateInterval: Int]
    let entries: [Date]

    init(_ state: MainReducer.State) {
      @Dependency(\.calendar) var cal: Calendar
      @Dependency(\.date.now) var now: Date

      day = state.amounts[cal.dateInterval(of: .day, for: now)!]
      before = state.amounts[cal.dateInterval(of: .day, for: now - 86400)!]
      week = state.amounts[cal.dateInterval(of: .weekOfYear, for: now)!]
      month = state.amounts[cal.dateInterval(of: .month, for: now)!]
      year = state.amounts[cal.dateInterval(of: .year, for: now)!]
      
      all = state.amounts[DateInterval(start: .distantPast, end: cal.startOfDay(for: now + 86400))]
      
      subdividedMonth = state.subdivide(cal.dateInterval(of: .month, for: now)!, by: .day)
      subdividedAll = state.subdivide(until: now, by: .day)
      
      entries = state.entries
    }
  }

  enum ViewAction: Equatable {
    case add, remove
    case calculateDay, calculateBefore, calculateWeek, calculateMonth, calculateYear
    case calculateAll
    case calculateSubdividedMonth, calculateSubdividedAll
    case addEntries([Date])

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
        return .calculateAmountForSubdivision(cal.dateInterval(of: .month, for: now)!, .day)
      case .calculateSubdividedAll: return .calculateAmountForSubdivisionUntil(now, .day)
      case let .addEntries(entries): return .setEntries(entries)
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
  }
}
#endif
