// Created by Leopold Lemmermann on 22.02.23.

import Dependencies
import SwiftUI
import Types

public struct DayPicker: View {
  @Binding var selection: Date
  let bounds: Interval

  public var body: some View {
    HStack {
      Button { selection = previousDay } label: {
        Label(String(localized: "previous day", comment: "Button label for going back one day."),
              systemImage: "chevron.left")
      }
        .disabled(bounds.start.flatMap { previousDay <= $0 } ?? false)
        .accessibilityIdentifier("previous-day-button")

      Spacer()

      DatePicker(
        String(localized: "pick", comment: "Label for selecting a date."),
        selection: $selection, in: (bounds.start ?? .distantPast) ... (bounds.end ?? .distantFuture)
      )
        .labelsHidden()
        .accessibilityElement()
        .accessibilityValue(selection.formatted(date: .numeric, time: .omitted))
        .accessibilityIdentifier("day-picker")

      Spacer()

      Button { selection = nextDay } label: {
        Label(String(localized: "next day", comment: "Button label for going forward one day."),
              systemImage: "chevron.right")
      }
        .disabled(bounds.end.flatMap { nextDay >= $0 } ?? false)
        .accessibilityIdentifier("next-day-button")
    }
  }

  @Dependency(\.calendar) private var cal
  @Dependency(\.date.now) private var now

  private var previousDay: Date { cal.date(byAdding: .day, value: -1, to: selection)! }
  private var nextDay: Date { cal.date(byAdding: .day, value: 1, to: selection)! }

  public init(selection: Binding<Date>, bounds: Interval = .alltime) {
    self._selection = selection
    self.bounds = bounds
  }
}

#Preview {
  DayPicker(selection: .constant(.now), bounds: .alltime)
    .buttonStyle(.borderedProminent)
    .labelStyle(.iconOnly)
    .padding()
}

#Preview("Upper bound") {
  DayPicker(selection: .constant(.now), bounds: .to(.now))
    .buttonStyle(.borderedProminent)
    .labelStyle(.iconOnly)
    .padding()
}

#Preview("Lower bound") {
  DayPicker(selection: .constant(.now), bounds: .from(.now))
    .buttonStyle(.borderedProminent)
    .labelStyle(.iconOnly)
    .padding()
}
