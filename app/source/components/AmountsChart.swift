// Created by Leopold Lemmermann on 24.04.23.

import Charts
import SwiftUI

// TODO: move the calculations into reducer

struct AmountsChart: View {
  let entries: [Date]?
  let bounds: Interval
  let subdivision: Subdivision
  let description: Text?

  var body: some View {
    ZStack {
      if let domain {
        DescriptedChartContent(data: amounts, description: description) { amounts in
          Chart(Array(amounts), id: \.key) { group, amount in
            BarMark(x: .value("DATE", group), y: .value("AMOUNT", amount))
          }
          .chartXScale(domain: domain)
          .minimumScaleFactor(0.5)
          .chartYAxisLabel(LocalizedStringKey("SMOKES"))
        }
      } else { ProgressView() }
    }
    .task {
      domain = await calculateDomain(grouping: grouping)
      amounts = await calculateAmounts(entries ?? [], grouping: grouping)
    }
    .onChange(of: entries) { newEntries in
      Task { amounts = await calculateAmounts(newEntries ?? [], grouping: grouping) }
    }
    .onChange(of: grouping) { newGrouping in
      Task {
        domain = await calculateDomain(grouping: newGrouping)
        amounts = await calculateAmounts(entries ?? [], grouping: newGrouping)
      }
    }
  }

  @State private var amounts: [String: Int]?
  @State private var domain: [String]?

  private var grouping: Date.FormatStyle {
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

  private func calculateAmounts(_ entries: [Date], grouping: Date.FormatStyle) async -> [String: Int] {
    entries.reduce(into: [String: Int]()) { counts, entry in
      counts[entry.formatted(grouping), default: 0] += 1
    }
  }

  private func calculateDomain(grouping: Date.FormatStyle) async -> [String] {
    NSOrderedSet(
      array: (bounds.enumerate(by: subdivision) ?? []).compactMap { $0.start?.formatted(grouping) }
    ).array as? [String] ?? []
  }
}

// MARK: - (PREVIEWS)

struct AmountsChart_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AmountsChart(
        entries: [.now - 86400, .now, .now],
        bounds: .fromTo(.init(start: .now - 86400, end: .now + 86400)),
        subdivision: .day,
        description: nil
      )

      AmountsChart(entries: nil, bounds: .alltime, subdivision: .day, description: nil)
        .previewDisplayName("Loading")
    }
    .padding()
  }
}
