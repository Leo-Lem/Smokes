import ComposableArchitecture
import SwiftUI

struct DashboardView: View {
  let store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store) { state in
      ViewState(
        day: state.amount(for: .now, in: .day),
        before: state.amount(for: Calendar.current.date(byAdding: .day, value: -1, to: .now)!, in: .day),
        week: state.amount(for: .now, in: .weekOfYear),
        month: state.amount(for: .now, in: .month),
        year: state.amount(for: .now, in: .year),
        all: state.amount(),
        daily: state.data(for: .now, in: .month, by: .day)
      )
    } send: { (action: ViewAction) in
      switch action {
      case .add: return .add(.now)
      case .remove: return .remove(.now)
      }
    } content: { viewStore in
      VStack {
        HStack {
          AmountWidget(viewStore.day, description: "today")
          AmountWidget(viewStore.before, description: "yesterday")
        }

        PlotWidget(description: "this month", data: viewStore.daily)

        HStack {
          AmountWidget(viewStore.week, description: "this week")
          AmountWidget(viewStore.month, description: "this month")
          AmountWidget(viewStore.year, description: "this year")
        }

        HStack {
          AmountWidget(viewStore.all, description: "until now")

          IncrementWidget(decrementDisabled: viewStore.day < 1) {
            viewStore.send(.add)
          } remove: {
            viewStore.send(.remove)
          }
        }
      }
      .padding()
    }
  }
}

extension DashboardView {
  struct ViewState: Equatable {
    let day: Int, before: Int, week: Int, month: Int, year: Int, all: Int
    let daily: [Date: Int]
  }

  enum ViewAction: Equatable {
    case add, remove
  }
}

// MARK: - (PREVIEWS)

struct DashboardView_Previews: PreviewProvider {
  static var previews: some View {
    DashboardView(store: .preview)
  }
}
