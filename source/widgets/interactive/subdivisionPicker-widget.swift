// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI

struct SubdivisionPickerWidget: View {
  @Binding var subdivision: Calendar.Component
  let subdivisions: [Calendar.Component]

  var body: some View {
    Picker("", selection: $subdivision) {
      ForEach(subdivisions, id: \.self) { subdivision in
        Text(format(subdivision)).tag(subdivision)
      }
    }
    .pickerStyle(.segmented)
  }

  private func format(_ component: Calendar.Component) -> String {
    @Dependency(\.calendar) var cal: Calendar
    switch component {
      case .year: return "year"
      case .month: return "month"
      case .day: return "day"
      case .hour: return "hour"
      case .minute: return "minute"
      case .second: return "second"
      case .quarter: return "quarter"
      case .weekOfYear: return "week"
      default: fatalError("Unavailable component: \(component)")
    }
  }

  private let formatter = DateComponentsFormatter()
}
