//
//  Content.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI

extension StatView {
    struct Content: View {
        let startDate: Date
        let calc: (Average) -> Double
        
        var body: some View {
            VStack {
                ForEach(Average.statCases(date, timespan), id:\.self) { average in
                    LabeledNumber(label: average.intervalName, number: String(format: "%.2f", calc(average)))
                        .rowItem().frame(maxHeight: 100)
                }
                Spacer()
                
                CustomDatePicker(.regular, date: $date, from: startDate)
                    .rowItem()
                
                Spacer()
                
                //TODO: Add Picker for selecting
                
                Picker("", selection: $timespan) {
                    ForEach(Average.timespanCases, id: \.self) { Text(Average.timespanName($0)) }
                }
                .pickerStyle(.segmented)
                .padding(.vertical, 5)
                .rowItem()
            }
        }
        
        @State private var date = Date()
        @State private var timespan: Average.Timespan = .alltime
    }
}

//MARK: - Previews
struct StatViewContent_Previews: PreviewProvider {
    static var previews: some View {
        StatView.Content(startDate: Date(), calc: {_ in 1})
    }
}

extension StatView.Content {
    #if DEBUG
    typealias Average = StateController.Average
    typealias LabeledNumber = MainView.LabeledNumber
    typealias CustomDatePicker = HistView.CustomDatePicker
    #endif
}
