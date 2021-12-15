//
//  MonthPicker.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 16.11.21.
//

import SwiftUI
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
            SymbolButtonView("chevron.left", size: 20) { date = date.addToValues([-1], for: [.year]) }
            .foregroundColor(date.getComponents().year == from.getComponents().year ? .gray : .black)
            YearMonthView($date, from: from, to: to)
            SymbolButtonView("chevron.right", size: 20) { date = date.addToValues([1], for: [.year]) }
            .foregroundColor(date.getComponents().year == to.getComponents().year ? .gray : .black)
        }.customBackground().padding(.horizontal)
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
                    date = date.setValues([0, 4*row+col+2, date.getComponents().year!], for: [.day, .month, .year])
                }) {
                    Text(monthDateFormatter.string(from: date.setValues([0, 4*row+col+2, date.getComponents().year!], for: [.day, .month, .year])))
                        .foregroundColor(.primary).font(.system(size: 9)).lineLimit(1).padding(5)
                        .frame(maxWidth: .infinity).customBackground()
                }
                .hidden(!(date.setValues([0, 4*row+col+2, date.getComponents().year!], for: [.day, .month, .year]).getComponents().year! == from.getComponents().year! && date.setValues([0, 4*row+col+2, date.getComponents().year!], for: [.day, .month, .year]).getComponents().month! < from.getComponents().month!))
                .hidden(!(date.setValues([0, 4*row+col+2, date.getComponents().year!], for: [.day, .month, .year]).getComponents().year! == to.getComponents().year! && date.setValues([0, 4*row+col+2, date.getComponents().year!], for: [.day, .month, .year]).getComponents().month! > to.getComponents().month!))
            }
        }
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
        Group {
            MonthPicker(date: .constant(Date()), from: Calendar.current.date(byAdding: .month, value: -48, to: Date())!, to: Date())
            MonthPicker(date: .constant(Date()), from: Calendar.current.date(byAdding: .month, value: -48, to: Date())!, to: Date())
        }
    }
}
