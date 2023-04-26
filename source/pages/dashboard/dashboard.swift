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
            untilNowAmountWidget(vs.untilHereAmount, porterButtonAlignment: .bottomLeading)
            incrementWidget(decrementDisabled: vs.dayAmount ?? 0 <= 0) { vs.send(.add) } remove: { vs.send(.remove) }
          }
        } else {
          GridRow {
            dayAmountWidget(vs.dayAmount).gridCellColumns(2)
            configurableAmountWidget { vs.configurableAmounts[$0]?.optional }
          }
            
          GridRow {
            untilNowAmountWidget(vs.untilHereAmount, porterButtonAlignment: .bottomLeading)
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
        vs.send(.loadDay)
        vs.send(.loadUntilNow)
        AmountOption.allCases.forEach { vs.send(.loadOption($0)) }
      }
    }
  }
  
  @State private var showingPorter = false
  @AppStorage("dashboard_amountOption") private var amountOption = AmountOption.week
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
  
  private func untilNowAmountWidget(_ amount: Int?, porterButtonAlignment: Alignment) -> some View {
    Widget {
      DescriptedValueContent(formatter.format(amount: amount), description: "UNTIL_NOW")
        .overlay(alignment: porterButtonAlignment) {
          Button { showingPorter = true } label: { Label("OPEN_PORTER", systemImage: "folder") }
            .labelStyle(.iconOnly)
            .accessibilityIdentifier("show-porter-button")
        }
        .sheet(isPresented: $showingPorter) { Porter().padding() }
    }
  }
  
  private func configurableAmountWidget(_ amount: @escaping (AmountOption) -> Int?) -> some View {
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
