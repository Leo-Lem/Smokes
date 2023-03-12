// Created by Leopold Lemmermann on 05.03.23.

import ComposableArchitecture
import SwiftUI

struct SubdivisionPicker: View {
  @Binding var subdivision: Calendar.Component
  let subdivisions: [Calendar.Component]

  var body: some View {
    Picker("", selection: $subdivision) {
      ForEach(subdivisions, id: \.self) { subdivision in
        Text(format(subdivision))
          .tag(subdivision)
      }
    }
    .labelsHidden()
    .pickerStyle(.segmented)
  }

  private func format(_ component: Calendar.Component) -> String {
    @Dependency(\.calendar) var cal: Calendar
    switch component {
    case .year: return "yearly"
    case .month: return "monthly"
    case .weekOfYear: return "weekly"
    case .day: return "daily"
    case .hour: return "hourly"
    default: fatalError("Unavailable component: \(component)")
    }
  }

  private let formatter = DateComponentsFormatter()
}
