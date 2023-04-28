// Created by Leopold Lemmermann on 01.04.23.

import ComposableArchitecture
import SwiftUI

struct DashboardView: View {
  @EnvironmentObject private var store: StoreOf<App>
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init, send: ViewAction.send) { vs in
      Grid {
        if vSize == .regular {
          dayAmountWidget(vs)

          GridRow {
            configurableAmountWidget(vs)
            configurableTimeWidget(vs)
          }
          
          GridRow {
            untilNowAmountWidget(vs, porterButtonAlignment: .bottomLeading)
            incrementWidget(vs)
          }
        } else {
          GridRow {
            dayAmountWidget(vs).gridCellColumns(2)
            configurableAmountWidget(vs)
          }
            
          GridRow {
            untilNowAmountWidget(vs, porterButtonAlignment: .bottomLeading)
            configurableTimeWidget(vs)
            incrementWidget(vs)
          }
        }
      }
      .animation(.default, value: vs.state)
      .animation(.default, value: amountOption)
      .animation(.default, value: timeOption)
      .onAppear { ViewAction.setup(vs) }
    }
  }
  
  @State private var showingPorter = false
  @AppStorage("dashboard_amountOption") private var amountOption = AmountOption.week
  @AppStorage("dashboard_timeOption") private var timeOption = TimeOption.sinceLast
  
  @Environment(\.verticalSizeClass) private var vSize
  
  @Dependency(\.formatter) private var formatter
}

extension DashboardView {
  private func dayAmountWidget(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    Widget {
      DescriptedValueContent(formatter.format(amount: vs.dayAmount), description: "TODAY")
    }
  }
  
  private func untilNowAmountWidget(
    _ vs: ViewStore<ViewState, ViewAction>, porterButtonAlignment: Alignment
  ) -> some View {
    Widget {
      DescriptedValueContent(formatter.format(amount: vs.untilHereAmount), description: "UNTIL_NOW")
        .overlay(alignment: porterButtonAlignment) {
          Button { showingPorter = true } label: { Label("OPEN_PORTER", systemImage: "folder") }
            .labelStyle(.iconOnly)
            .accessibilityIdentifier("show-porter-button")
        }
        .sheet(isPresented: $showingPorter) { Porter().padding() }
    }
  }
  
  private func configurableAmountWidget(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    ConfigurableWidget(selection: $amountOption) { option in
      DescriptedValueContent(formatter.format(amount: vs.configurableAmounts[option]), description: option.description)
    }
  }
  
  private func configurableTimeWidget(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    ConfigurableWidget(selection: $timeOption) { option in
      DescriptedValueContent(
        formatter.format(time: timeOption == .sinceLast ? vs.break : vs.longestBreak), description: option.description
      )
    }
  }
  
  private func incrementWidget(_ vs: ViewStore<ViewState, ViewAction>) -> some View {
    Widget {
      IncrementMenu(decrementDisabled: vs.dayAmount ?? 0 <= 0) { vs.send(.add) } remove: { vs.send(.remove) }
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
    .environmentObject(Store(initialState: .init(), reducer: App()))
  }
}
#endif
