import ComposableArchitecture
import SwiftUI

struct HistoryView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store) {
      ViewState($0, selectedDate: selectedDate)
    } send: {
      ViewAction.send($0, selectedDate: selectedDate)
    } content: { viewStore in
      GeometryReader { _ in
        VStack {
          Group {
            HStack {
              AmountWidget(viewStore.day, description: "this day")
                .overlay(alignment: .topTrailing) {
                  if !isEditing {
                    Button { isEditing = true } label: {
                      Image(systemName: "square.and.pencil")
                        .imageScale(.large)
                        .font(.headline)
                        .padding(5)
                    }
                  }
                }
                .widgetStyle()
                .onAppear { viewStore.send(.calculateDay) }
              
              if isEditing {
                IncrementWidget(decrementDisabled: viewStore.day ?? 0 < 1) {
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
                .widgetStyle()
              }
            }
            
            HStack {
              AmountWidget(viewStore.week, description: "this week")
                .widgetStyle()
                .onAppear { viewStore.send(.calculateWeek) }
              AmountWidget(viewStore.month, description: "this month")
                .widgetStyle()
                .onAppear { viewStore.send(.calculateMonth) }
              AmountWidget(viewStore.year, description: "this year")
                .widgetStyle()
                .onAppear { viewStore.send(.calculateYear) }
            }
            
            AmountWidget(viewStore.all, description: "until this day")
              .widgetStyle()
              .onAppear { viewStore.send(.calculateAll) }
          }
          .onLongPressGesture { isEditing.toggle() }
          
          DatePickerWidget(selection: $selectedDate)
            .widgetStyle()
            .frame(maxHeight: 50)
            .padding(.top)
        }
        .padding()
        .animation(.default, value: isEditing)
        .animation(.default, value: viewStore.state)
        .onChange(of: selectedDate) { _ in
          viewStore.send(.calculateDay)
          viewStore.send(.calculateWeek)
          viewStore.send(.calculateMonth)
          viewStore.send(.calculateYear)
          viewStore.send(.calculateAll)
        }
      }
    }
  }

  @State private var selectedDate = Dependency(\.date.now).wrappedValue - 86400
  @State private var isEditing = false
}

extension HistoryView {
  struct ViewState: Equatable {
    let day: Int?, week: Int?, month: Int?, year: Int?, all: Int?

    init(_ state: MainReducer.State, selectedDate: Date) {
      @Dependency(\.calendar) var cal: Calendar

      day = state.amounts[cal.dateInterval(of: .day, for: selectedDate)!]
      week = state.amounts[cal.dateInterval(of: .weekOfYear, for: selectedDate)!]
      month = state.amounts[cal.dateInterval(of: .month, for: selectedDate)!]
      year = state.amounts[cal.dateInterval(of: .year, for: selectedDate)!]
      all = state.amounts[DateInterval(start: .distantPast, end: cal.startOfDay(for: selectedDate + 86400))]
    }
  }

  enum ViewAction: Equatable {
    case add, remove
    case calculateDay, calculateWeek, calculateMonth, calculateYear, calculateAll

    static func send(_ action: Self, selectedDate: Date) -> MainReducer.Action {
      @Dependency(\.calendar) var cal: Calendar

      switch action {
      case .add: return .add(selectedDate)
      case .remove: return .remove(selectedDate)
      case .calculateDay: return .calculateAmount(cal.dateInterval(of: .day, for: selectedDate)!)
      case .calculateWeek: return .calculateAmount(cal.dateInterval(of: .weekOfYear, for: selectedDate)!)
      case .calculateMonth: return .calculateAmount(cal.dateInterval(of: .month, for: selectedDate)!)
      case .calculateYear: return .calculateAmount(cal.dateInterval(of: .year, for: selectedDate)!)
      case .calculateAll:
        return .calculateAmount(DateInterval(start: .distantPast, end: cal.startOfDay(for: selectedDate + 86400)))
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct HistoryView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryView()
      .environmentObject(StoreOf<MainReducer>(initialState: .preview, reducer: MainReducer()))
  }
}
#endif
