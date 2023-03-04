// Created by Leopold Lemmermann on 22.02.23.

import SwiftUI

struct DatePickerWidget: View {
  @Binding var selection: Date
  
  var body: some View {
    DatePicker("", selection: $selection, in: ...Date.now, displayedComponents: .date)
      .labelsHidden()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .widgetStyle()
  }
}

struct DatePickerWidget_Previews: PreviewProvider {
  static var previews: some View {
    DatePickerWidget(selection: .constant(.now))
  }
}
