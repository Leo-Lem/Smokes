import ComposableArchitecture
import SwiftUI

struct HistoryView: View {
  let store: StoreOf<MainReducer>
  
  var body: some View {
    WithViewStore(store) { state in
      ViewState(
        day: state.amount(for: selectedDate, in: .day),
        week: state.amount(for: selectedDate, in: .weekOfYear),
        month: state.amount(for: selectedDate, in: .month),
        all: state.amount(to: selectedDate)
      )
    } send: { (action: ViewAction) in
      switch action {
      case .add: return .add(selectedDate)
      case .remove: return .remove(selectedDate)
      }
    } content: { viewStore in
      VStack {
        Group {
          AmountWidget(viewStore.day, description: "This Day")
            
          HStack {
            AmountWidget(viewStore.week, description: "This Week")
            AmountWidget(viewStore.month, description: "This Month")
          }
            
          AmountWidget(viewStore.all, description: "Until This Day")
        }
        
        .onLongPressGesture { isEditing.toggle() }
          
        DatePickerWidget(selection: $selectedDate)
          .frame(maxHeight: 50)
          
        if isEditing {
          IncrementWidget(decrementDisabled: viewStore.day < 1) {
            viewStore.send(.add)
          } remove: {
            viewStore.send(.remove)
          }
          .overlay(alignment: .topTrailing) {
            Button { isEditing = false } label: {
              Image(systemName: "xmark.circle")
                .imageScale(.large)
                .font(.headline)
                .padding(5)
            }
          }
        }
      }
      .padding()
      .animation(.default, value: isEditing)
    }
  }
  
  @State private var selectedDate = Date.now
  @State private var isEditing = false
}

extension HistoryView {
  struct ViewState: Equatable {
    let day: Int, week: Int, month: Int, all: Int
  }
  
  enum ViewAction: Equatable {
    case add, remove
  }
}

// MARK: - (PREVIEWS)

struct HistoryView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryView(store: .preview)
  }
}
