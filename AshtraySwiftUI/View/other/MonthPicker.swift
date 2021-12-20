//
//  MonthPicker.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 16.11.21.
//

import SwiftUI
import MyLayout
import MyCustomUI

struct MonthPicker: View {
    @Binding var date: Date {
        didSet {
            if date.getComponents().year! < from.getComponents().year! || date.getComponents().year! > to.getComponents().year! {
                date = oldValue
            }
        }
    }
    let from: Date, to: Date
    
    var body: some View {
        HStack {
            SymbolButton("chevron.left", size: 20) {
                date.addToValue(-1, for: .year)
            }
            .foregroundColor(date.getComponents().year == from.getComponents().year ? .gray : .black)
            
            YearMonthView($date, from: from, to: to)
            
            SymbolButton("chevron.right", size: 20) {
                date.addToValue(1, for: .year)
            }
            .foregroundColor(date.getComponents().year == to.getComponents().year ? .gray : .black)
        }
    }
}


struct YearMonthView: View {
    @Binding var date: Date
    let from: Date, to: Date
    let monthDateFormatter = DateFormatter()
    
    var body: some View {
        ZStack {
            Text(String(date.getComponents().year!)).font(size: 70)
            GridStack(rows: 3, columns: 4) { row, col in
                Button(action: {
                    date.setValue([0, 4*row+col+2], for: [.day, .month])
                }) {
                    Text(monthDateFormatter.string(from: date.getDateWithValueSet([0, 4*row+col+2, date.asDateComponents.year!],
                                                                                  for: [.day, .month, .year])))
                        .foregroundColor(.primary)
                        .font(.system(size: 9))
                        .lineLimit(1)
                        .padding(5)
                        .frame(maxWidth: .infinity)
                }
                .background(Color.accentColor)
                .cornerRadius(LayoutDefaults.cornerRadius)
                .hidden(isMonthOutOfBounds(row: row, col: col))
            }
        }
    }
    
    private func isMonthOutOfBounds(row: Int, col: Int) -> Bool {
        let monthDate = date.getDateWithValueSet([0, 4*row+col+2, date.asDateComponents.year!],
                                                 for: [.day, .month, .year])
        return (
            monthDate.asDateComponents.year! == from.asDateComponents.year! &&
            monthDate.asDateComponents.month! < from.asDateComponents.month!
            ||
            monthDate.getComponents().year! == to.getComponents().year! &&
            monthDate.getComponents().month! > to.getComponents().month!
        )
    }
}

extension YearMonthView {
    init(_ date: Binding<Date>, from: Date, to: Date = Date()) {
        self._date = date; self.from = from; self.to = to
        monthDateFormatter.dateFormat = "MMMM"
    }
}

struct MonthPicker_Previews: PreviewProvider {
    static var previews: some View {
        MonthPicker(date: .constant(Date()),
                    from: Calendar.current.date(byAdding: .month, value: -48, to: Date())!,
                    to: Date())
            .preview()
    }
}
