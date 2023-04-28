// Created by Leopold Lemmermann on 08.03.23.

import Dependencies
import SwiftUI

struct IntervalPicker: View {
  @Binding var selection: Interval
  let bounds: Interval
  
  var body: some View {
    HStack {
      Button { selection ?= previous } label: { Label("PREVIOUS", systemImage: "chevron.left") }
        .disabled(previous == nil)
        .accessibilityIdentifier("previous-button")
      
      Picker("MONTH", selection: monthBinding) {
        Text("-")
          .tag(Int?.none)

        ForEach(months, id: \.self) { month in
          Text(format(month: month))
            .tag(Int?.some(month))
        }
      }
      .highlight(when: selection.subdivision == .month)
        
      Picker("YEAR", selection: yearBinding) {
        ForEach(years, id: \.self) { year in
          Text(format(year: year))
            .tag(year)
        }
      }
      .highlight(when: selection.subdivision == .month || selection.subdivision == .year)
      
      Button { selection ?= next } label: { Label("NEXT", systemImage: "chevron.right") }
        .disabled(next == nil)
        .accessibilityIdentifier("next-button")
      
      Spacer()
      
      Button { selection = selection == .alltime ? lastSelection : .alltime } label: {
        Label("UNTIL_NOW", systemImage: "chevron.forward.to.line")
      }
      .highlight(when: selection == .alltime)
    }
    .minimumScaleFactor(0.5)
    .lineLimit(1)
    .animation(.default, value: selection)
    .onChange(of: selection) { [selection] _ in lastSelection = selection }
  }
  
  @State private var lastSelection: Interval
  private var yearMonthSelection: Interval { selection == .alltime ? lastSelection : selection }
  
  @Dependency(\.calendar) private var cal
  
  init(selection: Binding<Interval>, bounds: Interval) {
    guard bounds.start != nil, bounds.end != nil else { fatalError("IntervalPicker requires bounds.") }
    
    self.bounds = bounds
    _selection = selection
    _lastSelection = State(initialValue: Interval.month(bounds.end!))
  }
}

extension IntervalPicker {
  private var previous: Interval? { yearMonthSelection.previous(in: bounds) }
  private var next: Interval? { yearMonthSelection.next(in: bounds) }
  
  private var lowerBound: Date { bounds.start! }
  private var upperBound: Date { bounds.end! }
  
  private var months: [Int] {
    Interval.year(yearMonthSelection.end ?? upperBound)
      .enumerate(by: .month, in: bounds)?
      .compactMap {
        guard let date = $0.start else { return nil}
        return cal.component(.month, from: date)
      }
    ?? []
  }
  
  private var years: [Int] {
    bounds.enumerate(by: .year)?.map { cal.component(.year, from: $0.start ?? lowerBound) } ?? []
  }
  
  private var monthBinding: Binding<Int?> {
    Binding {
      if yearMonthSelection.subdivision == .month {
        return cal.component(.month, from: yearMonthSelection.end ?? upperBound)
      } else { return nil }
    } set: { newValue in
      let year = cal.component(.year, from: yearMonthSelection.end ?? upperBound)
      
      if let newValue {
        selection = .month(cal.date(from: DateComponents(year: year, month: newValue))!)
      } else {
        selection = .year(cal.date(from: DateComponents(year: year))!)
      }
    }
  }
  
  private var yearBinding: Binding<Int> {
    Binding { cal.component(.year, from: yearMonthSelection.start ?? upperBound) } set: { newValue in
      let date = cal.date(from: DateComponents(year: newValue))!
      
      if yearMonthSelection.subdivision == .year {
        selection = .year(date)
      } else if yearMonthSelection.subdivision == .month {
        selection = .month(date)
      }
    }
  }
}

extension IntervalPicker {
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
