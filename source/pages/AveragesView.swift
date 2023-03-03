import ComposableArchitecture
import SwiftUI

struct AveragesView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store) { state in
      ViewState(
        daily: state.average(by: .day),
        weekly: state.average(by: .weekOfYear),
        monthly: state.average(by: .month)
      )
    } content: { viewStore in
      VStack {
        AmountWidget(viewStore.daily, description: "daily")
        
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
  }
}

// MARK: - (PREVIEWS)

struct AveragesView_Previews: PreviewProvider {
  static var previews: some View {
    AveragesView(store: .preview)
  }
}
