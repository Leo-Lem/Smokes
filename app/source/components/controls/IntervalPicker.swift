// Created by Leopold Lemmermann on 08.03.23.

import SwiftUI

struct IntervalPicker: View {
  @Binding var selection: Interval
  let bounds: Interval
  
  var body: some View {
    HStack {
      Button {
        if selectedMonth != nil { selectedMonth = previous } else { selectedYear ?= previous }
      } label: { Label("PREVIOUS", systemImage: "chevron.left") }
        .disabled(previous == nil)
        .accessibilityIdentifier("previous-button")
      
      Picker("MONTH", selection: $selectedMonth) {
        Text("-")
          .tag(Interval?.none)

        ForEach(months, id: \.self) { month in
          Text(month.end!.formatted(Date.FormatStyle().month(.abbreviated)))
            .tag(Optional(month))
        }
      }
      .highlight(when: !selectedAlltime && selectedMonth != nil)
        
      Picker("YEAR", selection: $selectedYear) {
        ForEach(years, id: \.self) { year in
          Text(year.end!.formatted(Date.FormatStyle().year(.defaultDigits)))
            .tag(year)
        }
      }
      .highlight(when: !selectedAlltime)
      
      Button {
        if selectedMonth != nil { selectedMonth = next } else { selectedYear ?= next }
      } label: { Label("NEXT", systemImage: "chevron.right") }
        .disabled(next == nil)
        .accessibilityIdentifier("next-button")
      
      Spacer()
      
      Button { selectedAlltime.toggle() } label: {
        Label("UNTIL_NOW", systemImage: "chevron.forward.to.line")
      }
      .highlight(when: selectedAlltime)
    }
    .minimumScaleFactor(0.5)
    .lineLimit(1)
    .animation(.default, value: selection)
    .animation(.default, value: selectedMonth)
    .animation(.default, value: selectedYear)
    .animation(.default, value: selectedAlltime)
    .onChange(of: selectedMonth) {
      if let month = $0 {
        selection = month
        selectedYear = .year(month.end!)
      } else {
        selection = selectedYear
      }
      selectedAlltime = false
    }
    .onChange(of: selectedYear) {
      if case .year = selection { selection = $0 }
    }
    .onChange(of: selectedAlltime) {
      if $0 { selection = .alltime } else { selection = selectedMonth ?? selectedYear }
    }
  }
  
  @State private var selectedMonth: Interval?
  @State private var selectedYear: Interval
  @State private var selectedAlltime: Bool
  
  private let lowerBound: Date
  private let upperBound: Date
  
  init(selection: Binding<Interval>, bounds: Interval) {
    guard let start = bounds.start, let end = bounds.end else { fatalError("IntervalPicker requires bounds.") }
    self.bounds = bounds
    
    _selection = selection
    _selectedMonth = .init(initialValue: .month(bounds.end!))
    _selectedYear = .init(initialValue: .year(bounds.end!))
    _selectedAlltime = .init(initialValue: selection.wrappedValue == .alltime)
    
    lowerBound = start
    upperBound = end
  }
}

extension IntervalPicker {
  private var previous: Interval? { (selectedMonth ?? selectedYear).previous(in: bounds) }
  private var next: Interval? { (selectedMonth ?? selectedYear).next(in: bounds) }
  
  private var years: [Interval] { bounds.enumerate(by: .year) ?? [] }
  private var months: [Interval] { selectedYear.enumerate(by: .month, in: bounds) ?? [] }
}

private extension View {
  func highlight(when isSelected: Bool) -> some View {
    shadow(color: .primary, radius: isSelected ? 5 : 0)
  }
}

// MARK: - (PREVIEWS)

struct ReducedIntervalPicker_Previews: PreviewProvider {
  static var previews: some View {
    Binding.Preview(Interval.alltime) { binding in
      IntervalPicker(
        selection: binding,
        bounds: .fromTo(.init(start: .init(timeIntervalSinceReferenceDate: 9_999_999), duration: 99_999_999))
      )
      .buttonStyle(.borderedProminent)
      .labelStyle(.iconOnly)
      .padding()
    }
  }
}
