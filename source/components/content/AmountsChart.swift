// Created by Leopold Lemmermann on 24.04.23.

import Charts
import SwiftUI

struct AmountsChart: View {
  let entries: [Date]?
  let bounds: Interval
  let subdivision: Subdivision
  let description: Text?
  
  var body: some View {
    DescriptedChartContent(data: entries, description: description) { data in
      Chart(groups(data), id: \.self) { group in
        BarMark(x: .value("DATE", group), y: .value("AMOUNT", amount(data, group: group)))
      }
      .chartXScale(domain: domain)
      .minimumScaleFactor(0.5)
      .chartYAxisLabel(LocalizedStringKey("SMOKES"))
    }
  }
  
  var grouping: Date.FormatStyle {
    switch (bounds, subdivision) {
    case (.week, .day): return .init().weekday(.abbreviated)
    case (.month, .day): return .init().day(.twoDigits)
    case (.month, .week): return .init().week(.weekOfMonth)
    case (.year, .day): return .init().day(.twoDigits).month(.twoDigits)
    case (.year, .week): return .init().week(.twoDigits)
    case (.year, .month): return .init().month(.abbreviated)
    case (_, .day): return .init().day(.twoDigits).month(.abbreviated).year(.defaultDigits)
    case (_, .week): return .init().week(.twoDigits).year(.defaultDigits)
    case (_, .month): return .init().month(.abbreviated).year(.defaultDigits)
    case (_, .year): return .init().year(.defaultDigits)
    }
  }
  
  var domain: [String] {
    bounds.enumerate(by: subdivision)?
      .reduce(into: [String]()) { result, next in
        let grouped = next.dateInterval.start.formatted(grouping)
        if !result.contains(grouped) { result.append(grouped) }
      }
      ?? []
  }
  
  func groups(_ data: [Date]) -> [String] {
    data.reduce(into: [String]()) { result, next in
      let next = next.formatted(grouping)
      if !result.contains(next) { result.append(next) }
    }
  }
                
  func amount(_ data: [Date], group: String) -> Int {
    if
      let last = data.lastIndex(where: { $0.formatted(grouping) == group }),
      let first = data.firstIndex(where: { $0.formatted(grouping) == group })
    {
      return last - first + 1
    } else { return 0 }
  }
}

// MARK: - (PREVIEWS)

struct AmountsChart_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AmountsChart(entries: nil, bounds: .alltime, subdivision: .day, description: nil)
        .previewDisplayName("Loading")
      
      AmountsChart(
        entries: [.startOfYesterday, .startOfToday, .startOfToday],
        bounds: .fromTo(.init(start: .startOfYesterday, end: .endOfToday)),
        subdivision: .week,
        description: nil
      )
    }
    .padding()
  }
}
