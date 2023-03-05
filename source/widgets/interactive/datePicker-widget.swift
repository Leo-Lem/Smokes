// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI
import ComposableArchitecture

struct DatePickerWidget: View {
  @Binding var selection: Date
  
  var body: some View {
    HStack {
      Button(systemImage: "chevron.left") { selection = cal.date(byAdding: .day, value: -1, to: selection)! }
      
      Spacer()
      
      DatePicker("", selection: $selection, in: ...now, displayedComponents: .date)
        .labelsHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      
      Spacer()
      
      Button(systemImage: "chevron.right") { selection = cal.date(byAdding: .day, value: 1, to: selection)! }
        .disabled(cal.isDate(selection, inSameDayAs: now))
    }
    .buttonStyle(.borderedProminent)
    .padding()
  }
  
  @Dependency(\.calendar) private var cal
  @Dependency(\.date.now) private var now
}

// MARK: (PREVIEWS) -

struct DatePickerWidget_Previews: PreviewProvider {
  static var previews: some View {
    DatePickerWidget(selection: .constant(.now))
      .padding()
  }
}
