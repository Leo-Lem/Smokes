//
//  Content.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI
import MyCustomUI

extension StatView {
    struct Content: View {
        let startDate: Date
        let calc: (Average) -> Double
        
        var body: some View {
            VStack {
                ForEach(Average.statCases(date, timespan), id: \.self) { stat in
                    LabeledNumber(label: stat.intervalName, number: String(format: "%.2f", calc(stat)))
                        .rowItem().frame(maxHeight: 80)
                        .hidden(hideStats(stat.kind))
                        .transition(.opacity)
                }
                
                Spacer()
                
                CustomDatePicker(.regular, date: $date, from: startDate)
                    .rowItem()
                
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
        
        private func hideStats(_ kind: (Average.Timespan, Average.Interval)) -> Bool {
            switch kind {
            case (.thisweek, .daily): return false
            case (.thisweek, _): return true
            case (.thismonth, .monthly): return true
            default: return false
            }
        }
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
    #endif
}
