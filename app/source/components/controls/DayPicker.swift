// Created by Leopold Lemmermann on 22.02.23.

import ComposableArchitecture
import SwiftUI

struct DayPicker: View {
  @Binding var selection: Date
  let bounds: Interval
  
  var body: some View {
    HStack {
      Button { selection = previousDay } label: { Label("PREVIOUS_DAY", systemImage: "chevron.left") }
        .disabled(bounds.start.flatMap { previousDay <= $0 } ?? false)
        .accessibilityIdentifier("previous-day-button")
      
      Spacer()
      
      DatePicker("", selection: $selection, in: (bounds.start ?? .distantPast) ... (bounds.end ?? .distantFuture))
        .labelsHidden()
        .accessibilityElement()
        .accessibilityLabel("PICK_DAY")
        .accessibilityValue(selection.formatted(date: .numeric, time: .omitted))
        .accessibilityIdentifier("day-picker")
      
      Spacer()
      
      Button { selection = nextDay } label: { Label("NEXT_DAY", systemImage: "chevron.right") }
        .disabled(bounds.end.flatMap { nextDay >= $0 } ?? false)
        .accessibilityIdentifier("next-day-button")
    }
  }
  
  @Dependency(\.calendar) private var cal
  @Dependency(\.date.now) private var now
  
  private var previousDay: Date { cal.date(byAdding: .day, value: -1, to: selection)! }
  private var nextDay: Date { cal.date(byAdding: .day, value: 1, to: selection)! }
}

// MARK: (PREVIEWS) -

#if DEBUG
struct DayPicker_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      DayPicker(selection: .constant(.now), bounds: .alltime)
      
      DayPicker(selection: .constant(.now), bounds: .to(.now))
        .previewDisplayName("Upper bound")
      
      DayPicker(selection: .constant(.now), bounds: .from(.now))
        .previewDisplayName("Lower bound")
    }
    .buttonStyle(.borderedProminent)
    .labelStyle(.iconOnly)
    .padding()
  }
}
#endif
