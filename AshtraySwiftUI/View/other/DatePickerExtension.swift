//
//  DatePickerView.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 11.11.21.
//

import SwiftUI

extension DatePicker {
    init(_ date: Binding<Date>, in range: ClosedRange<Date>) where Label == Text {
        self.init("", selection: date, in: range, displayedComponents: .date)
    }
    
    init(_ date: Binding<Date>, from: Date) where Label == Text {
        self.init("", selection: date, in: from..., displayedComponents: .date)
    }
    
    init(_ date: Binding<Date>, to: Date) where Label == Text {
        self.init("", selection: date, in: ...to, displayedComponents: .date)
    }
    
    init(_ date: Binding<Date>) where Label == Text {
        self.init("", selection: date, displayedComponents: .date)
    }
}
