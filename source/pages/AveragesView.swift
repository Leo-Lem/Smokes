import ComposableArchitecture
import SwiftUI

struct AveragesView: View {
  let store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store) { state in
      ViewState(
        daily: state.average(for: .now, in: .day, by: .day),
        weekly: state.average(for: .now, in: .weekOfYear, by: .day),
        monthly: state.average(for: .now, in: .month, by: .day),
        dailyThisMonth: state.average(for: .now, in: .month, by: .day),
        dailyLastMonth: state.average(
          for: Calendar.current.date(byAdding: .month, value: -1, to: .now)!, in: .month, by: .day
        ),
        dailyThisWeek: state.average(for: .now, in: .weekOfYear, by: .day),
        dailyLastWeek: state.average(
          for: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!, in: .weekOfYear, by: .day
        )
      )
    } content: { viewStore in
      VStack {
        AmountWidget(viewStore.daily, description: "daily")
        
        HStack {
          AmountWidget(viewStore.dailyLastWeek, description: "last week")
          AmountWidget(viewStore.dailyThisWeek, description: "this week")
        }

        HStack {
          AmountWidget(viewStore.dailyLastMonth, description: "last month")
          AmountWidget(viewStore.dailyThisMonth, description: "this month")
        }
        
        HStack {
          AmountWidget(viewStore.weekly, description: "weekly")
          AmountWidget(viewStore.monthly, description: "monthly")
        }
      }
      .padding()
    }
  }
}

extension AveragesView {
  struct ViewState: Equatable {
    let daily: Double, weekly: Double, monthly: Double
    let dailyThisMonth: Double, dailyLastMonth: Double
    let dailyThisWeek: Double, dailyLastWeek: Double
  }
}

// MARK: - (PREVIEWS)

struct AveragesView_Previews: PreviewProvider {
  static var previews: some View {
    AveragesView(store: .preview)
  }
}
