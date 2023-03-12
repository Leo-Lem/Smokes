// Created by Leopold Lemmermann on 12.03.23.

import ComposableArchitecture
import SwiftUI

struct StatsView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>
  
  var body: some View {
    VStack {
      AmountsPlotView(interval: selection, subdivision: showingAlltime ? .weekOfYear : .day)
      AveragesView(interval: selection)
      
      HStack {
        Widget {
          WithViewStore(store, observe: \.startDate) { startDate in
            MonthPicker(selection: $selectedMonth, bounds: DateInterval(start: startDate.state, end: now))
              .onChange(of: selectedMonth) { _ in showingAlltime = false }
              .padding(10)
          }
        }
        .onTapGesture { showingAlltime = false }

        Widget {
          Button { showingAlltime.toggle() } label: { Label("Alltime", systemImage: "arrow.right.to.line") }
            .labelStyle(.titleOnly)
            .disabled(showingAlltime)
            .padding(10)
            .onTapGesture { showingAlltime.toggle() }
        }
      }
      .buttonStyle(.borderedProminent)
      .frame(maxHeight: 80)
      .padding(.top)
    }
  }
  
  @State private var selectedMonth: DateInterval
  @State private var showingAlltime = true
  
  private var selection: DateInterval? { showingAlltime ? nil : selectedMonth }

  @Dependency(\.date.now) private var now: Date
  
  init() {
    @Dependency(\.calendar) var cal: Calendar
    @Dependency(\.date.now) var now: Date
    _selectedMonth = State(initialValue: cal.dateInterval(of: .month, for: now)!)
  }
}

// MARK: - (PREVIEWS)

struct StatsView_Previews: PreviewProvider {
  static var previews: some View {
    StatsView()
      .environmentObject(StoreOf<MainReducer>(initialState: .preview, reducer: MainReducer()))
      .padding()
  }
}
