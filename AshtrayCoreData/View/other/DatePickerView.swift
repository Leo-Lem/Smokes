//
//  DatePickerView.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 11.11.21.
//

import SwiftUI
import MyDates

public struct DatePickerView: View {
    private enum DatePickerBounds {
        case from, to, both, none
    }
    private let bounds: DatePickerBounds
    @Binding private var date: Date
    private var from: Date = Date(), to: Date = Date()
    
    public var body: some View {
        Group {
            switch bounds {
            case .none: DatePicker("", selection: $date, displayedComponents: [.date])
            case .both: DatePicker("", selection: $date, in: from...to, displayedComponents: [.date])
            case .from: DatePicker("", selection: $date, in: from..., displayedComponents: [.date])
            case .to: DatePicker("", selection: $date, in: ...to, displayedComponents: [.date])
            }
        }
        .labelsHidden()
        .frame(maxWidth: .infinity)
        .padding()
        .customBackground()
        .padding(.horizontal)
    }
    
    public init<T: ConvertibleDate>(_ date: Binding<Date>, from: T, to: T) {
        self._date = date
        self.from = getDate(from)
        self.to = getDate(to)
        self.bounds = .both
    }
    public init<T: ConvertibleDate>(_ date: Binding<Date>, from: T) {
        self._date = date
        self.from = getDate(from)
        self.bounds = .from
    }
    public init<T: ConvertibleDate>(_ date: Binding<Date>, to: T) {
        self._date = date
        self.to = getDate(to)
        self.bounds = .to
    }
    public init(_ date: Binding<Date>) {
        self._date = date
        self.bounds = .none
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView(.constant(Date()))
    }
}
