// Created by Leopold Lemmermann on 12.03.23.

import ComposableArchitecture
import SwiftUI

struct StatsView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store) {
      ViewState($0, interval: selection, subdivision: subdivision)
    } send: {
      ViewAction.send($0, interval: selection, subdivision: subdivision)
    } content: { viewStore in
      Render(
        selectedMonth: $selectedMonth, showingAlltime: $showingAlltime,
        startDate: viewStore.startDate,
        subdivision: subdivision,
        averages: viewStore.averages, subdivided: viewStore.subdivided, averageTimeBetween: viewStore.averageTimeBetween
      )
      .animation(.default, value: viewStore.state)
      .onAppear {
        viewStore.send(.calculateAverages)
        viewStore.send(.calculateSubdivision)
      }
      .onChange(of: selection) { _ in
        viewStore.send(.calculateAverages)
        viewStore.send(.calculateSubdivision)
      }
    }
  }
  
  @State private var selectedMonth: DateInterval
  @State private var showingAlltime = true

  private var selection: DateInterval? { showingAlltime ? nil : selectedMonth }
  private var subdivision: Calendar.Component { showingAlltime ? .month : .weekOfYear }

  init() {
    @Dependency(\.calendar) var cal: Calendar
    @Dependency(\.date.now) var now: Date
    _selectedMonth = State(initialValue: cal.dateInterval(of: .month, for: now)!)
  }
}

extension StatsView {
  struct ViewState: Equatable {
    let startDate: Date
    let averages: [Calendar.Component: Double?]
    let subdivided: [DateInterval: Int]
    let averageTimeBetween: TimeInterval?

    init(_ state: MainReducer.State, interval: DateInterval?, subdivision: Calendar.Component) {
      @Dependency(\.date.now) var now: Date
      @Dependency(\.calendar) var cal: Calendar
      let endOfDay = cal.endOfDay(for: now)
      
      startDate = state.startDate

      var adjustedInterval: DateInterval {
        switch interval {
        case .none:
          return DateInterval(start: state.startDate, end: endOfDay)
        case let .some(interval) where interval.end >= endOfDay:
          return DateInterval(start: interval.start, end: endOfDay)
        case let .some(interval):
          return interval
        }
      }
      subdivided = state.subdivide(adjustedInterval, by: subdivision) ?? [:]
      averages = Dictionary(
        uniqueKeysWithValues: [Calendar.Component.day, .weekOfYear, .month]
          .map { ($0, state.average(adjustedInterval, by: $0)) }
      )
      
      averageTimeBetween = state.averageTimeBetween(adjustedInterval)
    }
  }

  enum ViewAction: Equatable {
    case calculateAverages
    case calculateSubdivision

    static func send(_ action: Self, interval: DateInterval?, subdivision: Calendar.Component) -> MainReducer.Action {
      @Dependency(\.date.now) var now: Date
      @Dependency(\.calendar) var cal: Calendar
      let endOfDay = cal.endOfDay(for: now)

      switch (action, interval) {
      case (.calculateAverages, .none):
        return .calculateAmountUntil(endOfDay)
      case let (.calculateAverages, .some(interval)) where interval.end >= endOfDay:
        return .calculateAmount(DateInterval(start: interval.start, end: endOfDay))
      case let (.calculateAverages, .some(interval)):
        return .calculateAmount(interval)
      case (.calculateSubdivision, .none):
        return .calculateAmountsUntil(endOfDay, subdivision)
      case let (.calculateSubdivision, .some(interval)) where interval.end >= endOfDay:
        return .calculateAmounts(DateInterval(start: interval.start, end: endOfDay), subdivision)
      case let (.calculateSubdivision, .some(interval)):
        return .calculateAmounts(interval, subdivision)
      }
    }
  }
}

extension StatsView {
  struct Render: View {
    @Binding var selectedMonth: DateInterval
    @Binding var showingAlltime: Bool
    let startDate: Date
    let subdivision: Calendar.Component
    let averages: [Calendar.Component: Double?], subdivided: [DateInterval: Int], averageTimeBetween: TimeInterval?

    var body: some View {
      GeometryReader { geo in
        VStack {
          Widget {
            DatedAmountsPlot(data: subdivided, description: subdivision == .day ? "DAILY" : "WEEKLY")
          }
          .frame(minHeight: geo.size.height / 3)
          
          HStack {
            Widget { AverageInfo(averages[.day]?.optional, description: "PER_DAY") }
            
            if showingAlltime {
              Widget { AverageInfo(averages[.month]?.optional, description: "PER_MONTH") }
                .transition(.move(edge: .trailing))
            } else {
              Widget { AverageInfo(averages[.weekOfYear]?.optional, description: "PER_WEEK") }
                .transition(.scale)
            }
          }
          
          Widget { TimeInfo(averageTimeBetween, description: "AVERAGE_TIME_BETWEEN") }
          
          HStack {
            Widget {
              MonthPicker(selection: $selectedMonth, bounds: DateInterval(start: startDate, end: now))
                .onChange(of: selectedMonth) { _ in showingAlltime = false }
                .padding(10)
            }
            .onTapGesture { showingAlltime = false }
            
            Widget {
              Button { showingAlltime = true } label: { Label("SELECT_ALLTIME", systemImage: "arrow.right.to.line") }
                .labelStyle(.titleOnly)
                .disabled(showingAlltime)
                .padding(10)
                .onTapGesture { showingAlltime = false }
                .accessibilityIdentifier("select-alltime-button")
            }
          }
          .buttonStyle(.borderedProminent)
          .frame(maxHeight: 80)
        }
      }
    }
    
    @Dependency(\.date.now) private var now: Date
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct StatsView_Previews: PreviewProvider {
  static var previews: some View {
    StatsView()
      .environmentObject(StoreOf<MainReducer>(initialState: .preview, reducer: MainReducer()))
      .padding()
  }
}
#endif
