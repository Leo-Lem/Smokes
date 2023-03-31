// Created by Leopold Lemmermann on 08.03.23.

import Dependencies
import SwiftUI

struct ReducedIntervalPicker: View {
  @Binding var selection: Selection
  let bounds: DateInterval
  
  var body: some View {
    HStack {
      Button { yearMonthSelection.decrement(in: bounds) } label: { Label("PREVIOUS", systemImage: "chevron.left") }
        .disabled(yearMonthSelection.isFirst(in: bounds))
        .accessibilityIdentifier("previous-button")
      
      Picker("MONTH", selection: monthBinding) {
        Text("-")
          .tag(Int?.none)
          
        ForEach(yearMonthSelection.months(in: bounds) ?? [], id: \.self) { month in
          Text(format(month: month))
            .tag(Int?.some(month))
        }
      }
      .highlight(when: selection.hasMonth)
        
      Picker("YEAR", selection: yearBinding) {
        ForEach(yearMonthSelection.years(in: bounds), id: \.self) { year in
          Text(format(year: year))
            .tag(year)
        }
      }
      .highlight(when: selection.hasYear)
      
      Button { yearMonthSelection.increment(in: bounds) } label: { Label("NEXT", systemImage: "chevron.right") }
        .disabled(yearMonthSelection.isLast(in: bounds))
        .accessibilityIdentifier("next-button")
      
      Spacer()
      
      Button { selection = selection.isAlltime ? lastSelection : .alltime } label: {
        Label("UNTIL_NOW", systemImage: "chevron.forward.to.line")
      }
        .highlight(when: selection.isAlltime)
    }
    .minimumScaleFactor(0.5)
    .lineLimit(1)
    .animation(.default, value: selection)
    .onChange(of: selection) { [selection] _ in lastSelection = selection }
  }
  
  private var yearMonthSelection: Selection {
    get { selection.isAlltime ? lastSelection : selection }
    nonmutating set { selection = newValue }
  }
  @State private var lastSelection: Selection
  
  @Dependency(\.calendar) private var cal
  
  init(selection: Binding<Selection>, bounds: DateInterval) {
    _selection = selection
    self.bounds = bounds
    
    @Dependency(\.calendar) var cal
    _lastSelection = State(initialValue: Selection.month(
      month: cal.component(.month, from: bounds.end), year: cal.component(.year, from: bounds.end)
    ))
  }
}

extension ReducedIntervalPicker {
  private var monthBinding: Binding<Int?> {
    Binding { yearMonthSelection.month } set: { newValue in
      let year = selection.year ?? cal.component(.year, from: bounds.end)
      
      if let newValue {
        yearMonthSelection = .month(month: newValue, year: year)
      } else {
        yearMonthSelection = .year(year)
      }
    }
  }
  
  private var yearBinding: Binding<Int> {
    let year = yearMonthSelection.year ?? cal.component(.year, from: bounds.end)
    return Binding { year } set: { newValue in
      if
        let month = selection.month,
          Selection.month(month: newValue, year: year).months(in: bounds)!.contains(month)
      {
        yearMonthSelection = .month(month: month, year: newValue)
      } else {
        yearMonthSelection = .year(newValue)
      }
    }
  }
}

extension ReducedIntervalPicker {
  private func format(year: Int) -> String {
    cal.date(from: DateComponents(year: year))!
      .formatted(Date.FormatStyle().year(.defaultDigits))
  }
  
  private func format(month: Int) -> String {
    cal.date(from: DateComponents(month: month))!
      .formatted(Date.FormatStyle().month(.abbreviated))
  }
}

private extension View {
  func highlight(when isSelected: Bool) -> some View {
    shadow(color: .primary, radius: isSelected ? 5 : 0)
  }
}

// MARK: - (PREVIEWS)

struct ReducedIntervalPicker_Previews: PreviewProvider {
  static var previews: some View {
    Binding.Preview(ReducedIntervalPicker.Selection.alltime) { binding in
      VStack {
        Spacer()
        
        ReducedIntervalPicker(
          selection: binding,
          bounds: .init(start: .init(timeIntervalSinceReferenceDate: 9_999_999), duration: 99_999_999)
        )
        .buttonStyle(.borderedProminent)
        .labelStyle(.iconOnly)
        .padding()
      }
    }
  }
}
