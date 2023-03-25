import ComposableArchitecture
import SwiftUI

struct DashboardView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store, observe: ViewState.init, send: ViewAction.send) { viewStore in
      Render(
        amounts: viewStore.amounts,
        subdividedMonth: viewStore.subdividedMonth,
        timeSinceLast: viewStore.timeSinceLast
      ) {
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

      switch self {
      case .day: return cal.dateInterval(of: .day, for: now)!
      case .before: return cal.dateInterval(of: .day, for: now - 86400)!
      case .week: return cal.dateInterval(of: .weekOfYear, for: now)!
      case .month: return cal.dateInterval(of: .month, for: now)!
      case .year: return cal.dateInterval(of: .year, for: now)!
      case .all: return DateInterval(start: .distantPast, end: cal.endOfDay(for: now))
      }
    }
  }

  struct ViewState: Equatable {
    let amounts: [Interval: Int?]
    let subdividedMonth: [DateInterval: Int]?
    let timeSinceLast: TimeInterval

    init(_ state: MainReducer.State) {
      @Dependency(\.calendar) var cal: Calendar
      @Dependency(\.date.now) var now: Date

      amounts = Dictionary(uniqueKeysWithValues: Interval.allCases.map { ($0, state.amounts[$0.dateInterval]) })
      subdividedMonth = state.subdivide(
        DateInterval(
          start: cal.date(byAdding: .month, value: -1, to: cal.startOfDay(for: now))!,
          end: cal.endOfDay(for: now)
        ),
        by: .day
      )
      timeSinceLast = state.timeSinceLast(for: .now)
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
    let timeSinceLast: TimeInterval
    let add: () -> Void, remove: () -> Void

    var body: some View {
      GeometryReader { geo in
        VStack {
          Widget {
            AmountInfo(amounts[.day]?.optional, description: "TODAY")
              .attachPlot {
                if let subdividedMonth {
                  DatedAmountsPlot(data: subdividedMonth, description: nil)
                } else { ProgressView() }
              }
              .frame(height: geo.size.height / 3)
          }

          HStack {
            Widget { AmountInfo(amounts[.before]?.optional, description: "YESTERDAY") }
            Widget { TimeInfo(timeSinceLast, description: "SINCE_LAST_SMOKE") }
          }

          HStack {
            Widget {
              AmountInfo(amounts[.all]?.optional, description: "UNTIL_NOW")
                .attachPorter()
            }

            Widget {
              IncrementMenu(decrementDisabled: amounts[.day]?.optional ?? 0 < 1, add: add, remove: remove)
            }
          }
        }
        .labelStyle(.iconOnly)
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
      DashboardView.Render(amounts: amounts, subdividedMonth: [:], timeSinceLast: 10) {} remove: {}

      DashboardView.Render(amounts: [:], subdividedMonth: [:], timeSinceLast: 1000) {} remove: {}
        .previewDisplayName("Loading")

      DashboardView.Render(amounts: amounts, subdividedMonth: subdividedMonth, timeSinceLast: 100) {} remove: {}
        .previewDisplayName("With plot data")
    }
    .padding()
  }
}
#endif
