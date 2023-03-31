// Created by Leopold Lemmermann on 12.03.23.

import ComposableArchitecture
import SwiftUI
import Charts

struct StatsView: View {
  @EnvironmentObject private var store: StoreOf<MainReducer>

  var body: some View {
    WithViewStore(store) {
      ViewState($0, selectedInterval: selection.dateInterval)
    } send: {
      ViewAction.send($0)
    } content: { vs in
      Grid {
        if vSize == .regular {
          configurableAverageWidget { vs.configurableAverages[$0]?.optional }
          
          amountsPlotWidget(
            vs.configurableEntries[averageOption],
            option: averageOption,
            bounds: selection.dateInterval.intersection(with: vs.bounds) ?? .init()
          )
          
          GridRow {
            averageTimeBetweenWidget(vs.averageTimeBetween)
            trendWidget(vs.configurableTrends[averageOption]?.optional)
          }
        } else {
          configurableAverageWidget { vs.configurableAverages[$0]?.optional }
          averageTimeBetweenWidget(vs.averageTimeBetween)
          trendWidget(vs.configurableTrends[averageOption]?.optional)
        }
        
        intervalPicker($selection, bounds: vs.bounds)
      }
      .animation(.default, value: vs.state)
      .onAppear {
        if let interval = selection.dateInterval.intersection(with: vs.bounds) {
          vs.send(.calculateAverageAmount(selectedInterval: interval))
          AverageOption.allCases.forEach { vs.send(.calculateTrendAmount($0, selectedInterval: interval)) }
        }
      }
      .onChange(of: selection) { new in
        if let interval = new.dateInterval.intersection(with: vs.bounds) {
          vs.send(.calculateAverageAmount(selectedInterval: interval))
          AverageOption.allCases.forEach { vs.send(.calculateTrendAmount($0, selectedInterval: interval)) }
        }
      }
    }
  }

  @AppStorage("history_selection") private var selection = ReducedIntervalPicker.Selection.alltime
  @AppStorage("history_averageOption") private var averageOption = AverageOption.perday
  
  @Environment(\.verticalSizeClass) private var vSize
  @Dependency(\.formatter) private var formatter
}

extension StatsView {
  private func trendWidget(_ trend: Double?) -> some View {
    Widget {
      DescriptedValueContent(
        formatter.format(trend: trend), description: Text(averageOption.description) + Text(" ") + Text("(TREND)")
      )
    }
  }
  
  private func configurableAverageWidget(_ average: @escaping (AverageOption) -> Double?) -> some View {
    ConfigurableWidget(selection: $averageOption) { option in
      DescriptedValueContent(formatter.format(average: average(option)), description: option.description)
    }
  }
  
  private func intervalPicker(
    _ selection: Binding<ReducedIntervalPicker.Selection>, bounds: DateInterval
  ) -> some View {
    Widget {
      ReducedIntervalPicker(selection: selection, bounds: bounds)
        .labelStyle(.iconOnly)
        .buttonStyle(.borderedProminent)
    }
  }
  
  private func averageTimeBetweenWidget(_ time: TimeInterval?) -> some View {
    Widget {
      DescriptedValueContent(formatter.format(time: time), description: "AVERAGE_TIME_BETWEEN")
    }
  }
  
  private func amountsPlotWidget(_ entries: [Date]?, option: AverageOption, bounds: DateInterval) -> some View {
    Widget {
      DescriptedChartContent(data: entries, description: nil) { data in
        Chart(option.groups(from: data), id: \.self) { group in
          BarMark(
            x: .value("DATE", group),
            y: .value("AMOUNT", option.amount(from: data, for: group))
          )
        }
        .chartXScale(domain: option.domain(bounds))
        .chartXAxisLabel(option.xLabel)
        .chartYAxisLabel(LocalizedStringKey("SMOKES"))
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct StatsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      StatsView()
        .environment(\.verticalSizeClass, .regular)
        .previewDisplayName("Regular")

      StatsView()
        .environment(\.verticalSizeClass, .compact)
        .previewDisplayName("Compact")
    }
    .padding()
    .environmentObject(Store(initialState: .init(), reducer: MainReducer()))
  }
}
#endif
