// Created by Leopold Lemmermann on 08.03.23.

import Dependencies
import SwiftUI

struct MonthPicker: View {
  @Binding var selection: DateInterval
  let bounds: DateInterval
  
  var body: some View {
    HStack {
      Button { selection = cal.dateInterval(of: .month, for: selection.start - 1)! } label: {
        Label("Previous", systemImage: "chevron.left")
      }
      .disabled(selection.start <= bounds.start)
      
      Spacer()
      
      Menu {
        ForEach(months, id: \.self) { month in
          Button(formatter.string(from: month.start)) { self.selection = month }
        }
      } label: {
        Text(formatter.string(from: selection.start))
          .lineLimit(1)
          .truncationMode(.tail)
      }
      
      Spacer()
      
      Button { selection = cal.dateInterval(of: .month, for: selection.end + 1)! } label: {
        Label("Next", systemImage: "chevron.right")
      }
      .disabled(selection.end >= bounds.end)
    }
    .labelStyle(.iconOnly)
  }
  
  @Dependency(\.calendar) private var cal: Calendar
  
  private var months: [DateInterval] {
    var months = [DateInterval](), date = bounds.start
    
    while date < bounds.end {
      months.append(cal.dateInterval(of: .month, for: date)!)
      date = cal.date(byAdding: .month, value: 1, to: date)!
    }
    
    return months.reversed()
  }
  
  private var formatter: DateFormatter {
    let df = DateFormatter()
    df.dateFormat = "MMM yy"
    return df
  }
  
  init(selection: Binding<DateInterval>, bounds: DateInterval) {
    _selection = selection
    self.bounds = bounds
  }
}

// MARK: - (PREVIEWS)

struct MonthPicker_Previews: PreviewProvider {
  static var previews: some View {
    MonthPicker(
      selection: .constant(.init()),
      bounds: .init(start: .now - 365 * 86400, end: .now)
    )
    .padding()
    .buttonStyle(.borderedProminent)
  }
}
