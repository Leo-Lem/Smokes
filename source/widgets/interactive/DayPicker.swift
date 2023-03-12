// Created by Leopold Lemmermann on 22.02.23.

import ComposableArchitecture
import SwiftUI

struct DayPicker: View {
  @Binding var selection: Date
  let bounds: DateInterval
  
  var body: some View {
    HStack {
      Button { selection = previousDay } label: { Label("PREVIOUS_DAY", systemImage: "chevron.left") }
        .disabled(previousDay <= bounds.start)
        .accessibilityIdentifier("previous-day-button")
      
      Spacer()
      
      DatePicker("", selection: $selection, in: bounds.start ... bounds.end, displayedComponents: .date)
        .labelsHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier("day-picker")
      
      Spacer()
      
      Button { selection = nextDay } label: { Label("NEXT_DAY", systemImage: "chevron.right") }
        .disabled(nextDay >= bounds.end)
        .accessibilityIdentifier("next-day-button")
    }
  }
  
  @Dependency(\.calendar) private var cal
  @Dependency(\.date.now) private var now
  
  private var previousDay: Date { cal.date(byAdding: .day, value: -1, to: selection)! }
  private var nextDay: Date { cal.date(byAdding: .day, value: 1, to: selection)! }
}

// MARK: (PREVIEWS) -

struct DayPicker_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      DayPicker(selection: .constant(.now), bounds: DateInterval(start: .distantPast, end: .distantFuture))
      
      DayPicker(selection: .constant(.now), bounds: DateInterval(start: .distantPast, end: .now))
        .previewDisplayName("Upper bound")
      
      DayPicker(selection: .constant(.now), bounds: DateInterval(start: .now, end: .distantFuture))
        .previewDisplayName("Lower bound")
    }
    .buttonStyle(.borderedProminent)
    .padding()
  }
}
