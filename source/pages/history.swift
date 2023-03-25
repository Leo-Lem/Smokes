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
      Render(selectedDate: $selectedDate, isEditing: $isEditing, amounts: viewStore.amounts) {
        viewStore.send(.add)
      } remove: {
        viewStore.send(.remove)
      }
      .animation(.default, value: isEditing)
      .animation(.default, value: viewStore.state)
      .onAppear { Interval.allCases.forEach { viewStore.send(.calculate($0)) } }
      .onChange(of: selectedDate) { _ in
        Interval.allCases.forEach { viewStore.send(.calculate($0)) }
      }
    }
  }

  @State private var selectedDate = Dependency(\.date.now).wrappedValue - 86400
  @State private var isEditing = false
}

extension HistoryView {
  enum Interval: CaseIterable {
    case day, week, month, year, all

    func dateInterval(selectedDate: Date) -> DateInterval {
      @Dependency(\.calendar) var cal: Calendar

      switch self {
      case .day: return cal.dateInterval(of: .day, for: selectedDate)!
      case .week: return cal.dateInterval(of: .weekOfYear, for: selectedDate)!
      case .month: return cal.dateInterval(of: .month, for: selectedDate)!
      case .year: return cal.dateInterval(of: .year, for: selectedDate)!
      case .all: return DateInterval(start: .distantPast, end: cal.endOfDay(for: selectedDate))
      }
    }
  }

  struct ViewState: Equatable {
    let amounts: [Interval: Int?]

    init(_ state: MainReducer.State, selectedDate: Date) {
      amounts = Dictionary(uniqueKeysWithValues: Interval.allCases.map {
        ($0, state.amounts[$0.dateInterval(selectedDate: selectedDate)])
      })
    }
  }

  enum ViewAction: Equatable {
    case add, remove, calculate(Interval)

    static func send(_ action: Self, selectedDate: Date) -> MainReducer.Action {
      switch action {
      case .add: return .add(selectedDate)
      case .remove: return .remove(selectedDate)
      case let .calculate(interval): return .calculateAmount(interval.dateInterval(selectedDate: selectedDate))
      }
    }
  }
}

extension HistoryView {
  struct Render: View {
    @Binding var selectedDate: Date
    @Binding var isEditing: Bool
    let amounts: [HistoryView.Interval: Int?]
    let add: () -> Void, remove: () -> Void

    var body: some View {
      VStack {
        Widget {
          HStack {
            AmountInfo(amounts[.day]?.optional, description: "THIS_DAY")
              .overlay(alignment: .topTrailing) {
                if !isEditing {
                  Button { isEditing = true } label: {
                    Label("MODIFY", systemImage: "square.and.pencil")
                      .font(.title2)
                      .accessibilityIdentifier("start-modifying-button")
                  }
                }
              }

            if isEditing {
              IncrementMenu(decrementDisabled: amounts[.day]?.optional ?? 0 < 1, add: add, remove: remove)
                .overlay(alignment: .topTrailing) {
                  Button { isEditing = false } label: {
                    Label("DISMISS", systemImage: "xmark.circle")
                      .font(.title2)
                      .accessibilityIdentifier("stop-modifying-button")
                  }
                }
                .transition(.move(edge: .trailing))
            }
          }
        }
        .onLongPressGesture { isEditing.toggle() }

        HStack {
          Widget { AmountInfo(amounts[.week]?.optional, description: "THIS_WEEK") }
          Widget { AmountInfo(amounts[.month]?.optional, description: "THIS_MONTH") }
        }

        HStack {
          Widget { AmountInfo(amounts[.year]?.optional, description: "THIS_YEAR") }
          Widget { AmountInfo(amounts[.all]?.optional, description: "UNTIL_THIS_DAY") }
        }

        Widget {
          DayPicker(
            selection: $selectedDate,
            bounds: DateInterval(start: .distantPast, end: Dependency(\.date.now).wrappedValue)
          )
          .buttonStyle(.borderedProminent)
          .padding(10)
        }
        .frame(maxHeight: 80)
      }
      .labelStyle(.iconOnly)
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct HistoryView_Previews: PreviewProvider {
  static var previews: some View {
    let amounts: [HistoryView.Interval: Int?] = [.day: 10, .week: 45, .month: 87, .year: 890, .all: 2450]

    Group {
      HistoryView.Render(
        selectedDate: .constant(.now - 86400), isEditing: .constant(false), amounts: amounts, add: {}, remove: {}
      )

      HistoryView.Render(
        selectedDate: .constant(.now - 86400), isEditing: .constant(true), amounts: amounts, add: {}, remove: {}
      )
      .previewDisplayName("Editing")

      HistoryView.Render(
        selectedDate: .constant(.now), isEditing: .constant(true), amounts: amounts, add: {}, remove: {}
      )
      .previewDisplayName("Date is now")
    }
    .padding()
  }
}
#endif
