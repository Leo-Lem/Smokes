//
//  DatePicker.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 22.01.22.
//

import SwiftUI
import MyCustomUI

extension StatView.Content {
    struct CustomDatePicker: View {
        @Binding var date: Date
        let bounds: (Date?, Date?)
        let kind: Kind
        
        var body: some View {
            Group {
                switch kind {
                default:
                    DatePicker($date, from: bounds.0, to: bounds.1)
                    //TODO: add the month picker again
                    //TODO: add the week picker
                }
            }
            .labelsHidden()
            .padding()
        }
        
        enum Kind { case regular, month, week }
        
        init(_ kind: Kind, date: Binding<Date>, from: Date? = nil, to: Date? = nil) {
            self.kind = kind
            self._date = date
            self.bounds = (from, to)
        }
    }
}

extension HistView.Content { typealias CustomDatePicker = StatView.Content.CustomDatePicker }

//TODO: move to package
extension DatePicker {
    init(
        label: String = "",
        _ date: Binding<Date>,
        from: Date? = nil, to: Date? = nil,
        comps: DatePicker<Text>.Components = .date
    ) where Label == Text {
        switch (from, to) {
        case (nil, nil): self.init(label, selection: date, displayedComponents: comps)
        case (_, nil): self.init(label, selection: date, in: from!..., displayedComponents: comps)
        case (nil, _): self.init(label, selection: date, in: ...to!, displayedComponents: comps)
        case (_, _): self.init(label, selection: date, in: from!...to!, displayedComponents: comps)
        }
    }
}
