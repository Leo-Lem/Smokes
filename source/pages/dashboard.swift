import ComposableArchitecture
import SwiftUI

struct DashboardView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store, observe: ViewState.init, send: ViewAction.send) { viewStore in
      Render(amounts: viewStore.amounts, subdividedMonth: viewStore.subdividedMonth) {
        viewStore.send(.add)
      } remove: {
        viewStore.send(.remove)
      }
      .animation(.default, value: viewStore.state)
      .onAppear {
        Interval.allCases.forEach { viewStore.send(.calculate($0)) }
        viewStore.send(.calculateSubdividedMonth)
      }
    }
  }
}

extension DashboardView {
  enum Interval: CaseIterable {
    case day, before, week, month, year, all

    var dateInterval: DateInterval {
      @Dependency(\.calendar) var cal: Calendar
      @Dependency(\.date.now) var now: Date
      let tomorrow = cal.startOfDay(for: now + 86400)

      switch self {
      case .day: return cal.dateInterval(of: .day, for: now)!
      case .before: return cal.dateInterval(of: .day, for: now - 86400)!
      case .week: return cal.dateInterval(of: .weekOfYear, for: now)!
      case .month: return cal.dateInterval(of: .month, for: now)!
      case .year: return cal.dateInterval(of: .year, for: now)!
      case .all: return DateInterval(start: .distantPast, end: tomorrow)
      }
    }
  }

  struct ViewState: Equatable {
    let amounts: [Interval: Int?]
    let subdividedMonth: [DateInterval: Int]?

    init(_ state: MainReducer.State) {
      @Dependency(\.calendar) var cal: Calendar
      @Dependency(\.date.now) var now: Date

      amounts = Dictionary(uniqueKeysWithValues: Interval.allCases.map { ($0, state.amounts[$0.dateInterval]) })
      subdividedMonth = state.subdivide(
        DateInterval(start: cal.dateInterval(of: .month, for: now)!.start, end: cal.startOfDay(for: now + 86400)),
        by: .day
      )
    }
  }

  enum ViewAction: Equatable {
    case add, remove
    case calculate(Interval)
    case calculateSubdividedMonth

    static func send(_ action: Self) -> MainReducer.Action {
      @Dependency(\.calendar) var cal: Calendar
      @Dependency(\.date.now) var now: Date

      switch action {
      case .add: return .add(now)
      case .remove: return .remove(now)
      case let .calculate(interval): return .calculateAmount(interval.dateInterval)
      case .calculateSubdividedMonth:
        return .calculateAmounts(cal.dateInterval(of: .month, for: now)!, .day)
      }
    }
  }
}

extension DashboardView {
  struct Render: View {
    let amounts: [DashboardView.Interval: Int?]
    let subdividedMonth: [DateInterval: Int]?
    let add: () -> Void, remove: () -> Void

    var body: some View {
      GeometryReader { geo in
        VStack {
          Widget {
            AmountWithLabel(amounts[.day]?.optional, description: "today")
              .attachPlot {
                if let subdividedMonth {
                  DatedAmountsPlot(data: subdividedMonth, description: nil)
                } else { ProgressView() }
              }
              .frame(height: geo.size.height / 3)
          }

          Widget { AmountWithLabel(amounts[.before]?.optional, description: "yesterday") }

          HStack {
            Widget { AmountWithLabel(amounts[.week]?.optional, description: "week") }
            Widget { AmountWithLabel(amounts[.month]?.optional, description: "month") }
            Widget { AmountWithLabel(amounts[.year]?.optional, description: "year") }
          }

          HStack {
            Widget {
              AmountWithLabel(amounts[.all]?.optional, description: "until now")
                .attachPorter()
            }

            Widget {
              IncrementMenu(decrementDisabled: amounts[.day]?.optional ?? 0 < 1, add: add, remove: remove)
            }
          }
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct DashboardView_Previews: PreviewProvider {
  static var previews: some View {
    let amounts: [DashboardView.Interval: Int?] = [.day: 10, .before: 8, .week: 45, .month: 87, .year: 890, .all: 2450]
    let subdividedMonth = [
      DateInterval(start: .now - 86400, duration: 86400): 10,
      DateInterval(start: .now, duration: 86400): 8,
      DateInterval(start: .now + 86400, duration: 86400): 4
    ]

    Group {
      DashboardView.Render(amounts: amounts, subdividedMonth: [:], add: {}, remove: {})
      
      DashboardView.Render(amounts: [:], subdividedMonth: [:], add: {}, remove: {})
        .previewDisplayName("Loading")
      
      DashboardView.Render(amounts: amounts, subdividedMonth: subdividedMonth, add: {}, remove: {})
        .previewDisplayName("With plot data")
    }
    .padding()
  }
}
#endif
