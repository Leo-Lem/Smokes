import ComposableArchitecture
import SwiftUI

struct DashboardView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init, send: ViewAction.send) { vs in
      Grid {
        if vSize == .regular {
          dayAmountWidget(vs.dayAmount)
          
          GridRow {
            configurableAmountWidget { vs.configurableAmounts[$0]?.optional }
            configurableTimeWidget(timeOption == .sinceLast ? vs.sinceLast : vs.longestBreak)
          }
          
          GridRow {
            untilNowAmountWidget(vs.untilHereAmount)
            incrementWidget(decrementDisabled: vs.dayAmount ?? 0 <= 0) { vs.send(.add) } remove: { vs.send(.remove) }
          }
        } else {
          GridRow {
            dayAmountWidget(vs.dayAmount).gridCellColumns(2)
            configurableAmountWidget { vs.configurableAmounts[$0]?.optional }
          }
            
          GridRow {
            untilNowAmountWidget(vs.untilHereAmount)
            configurableTimeWidget(timeOption == .sinceLast ? vs.sinceLast : vs.longestBreak)
            incrementWidget(decrementDisabled: vs.dayAmount ?? 0 <= 0) { vs.send(.add) } remove: { vs.send(.remove) }
          }
        }
      }
      .animation(.default, value: vs.state)
      .animation(.default, value: vSize)
      .animation(.default, value: amountOption)
      .animation(.default, value: timeOption)
      .onAppear {
        vs.send(.calculateDay)
        vs.send(.calculateUntilHere)
        IntervalOption.allCases.forEach { vs.send(.calculateOption($0)) }
      }
    }
  }
  
  @State private var showingPorter = false
  @AppStorage("dashboard_amountOption") private var amountOption = IntervalOption.week
  @AppStorage("dashboard_timeOption") private var timeOption = TimeOption.sinceLast
  
  @Environment(\.verticalSizeClass) private var vSize
  
  @Dependency(\.formatter) private var formatter
}

extension DashboardView {
  private func dayAmountWidget(_ amount: Int?) -> some View {
    Widget {
      DescriptedValueContent(formatter.format(amount: amount), description: "TODAY")
    }
  }
  
  private func untilNowAmountWidget(_ amount: Int?) -> some View {
    Widget {
      DescriptedValueContent(formatter.format(amount: amount), description: "UNTIL_NOW")
    }
  }
  
  private func configurableAmountWidget(_ amount: @escaping (IntervalOption) -> Int?) -> some View {
    ConfigurableWidget(selection: $amountOption) { option in
      DescriptedValueContent(formatter.format(amount: amount(option)), description: option.description)
    }
  }
  
  private func configurableTimeWidget(_ time: TimeInterval?) -> some View {
    ConfigurableWidget(selection: $timeOption) { option in
      DescriptedValueContent(formatter.format(time: time), description: option.description)
    }
  }
  
  private func incrementWidget(
    decrementDisabled: Bool, add: @escaping () -> Void, remove: @escaping () -> Void
  ) -> some View {
    Widget {
      IncrementMenu(decrementDisabled: decrementDisabled, add: add, remove: remove)
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct DashboardView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      DashboardView()
        .environment(\.verticalSizeClass, .regular)
        .previewDisplayName("Regular")

      DashboardView()
        .environment(\.verticalSizeClass, .compact)
        .previewDisplayName("Compact")
    }
    .padding()
    .environmentObject(Store(initialState: .init(), reducer: MainReducer()))
  }
}
#endif
