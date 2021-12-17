//
//  Averages.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.07.21.
//

import SwiftUI
import MyCustomUI

struct AverageView: View {
    @EnvironmentObject private var model: AshtrayModel
    @EnvironmentObject private var viewModel: AshtrayViewModel
    
    @State private var timespan: CountCategories.Average.Span = .alltime
    private var intervalHidden: [CountCategories.Average.Interval: Bool] {
        [.daily: false,
         .weekly: timespan == .thisweek,
         .monthly: timespan == .thisweek || timespan == .thismonth]
    }
    @State private var date = Date()
    
    var body: some View {
        VStack {
            ForEach(CountCategories.Average.Interval.allCases, id:\.self) { interval in
                CountDisplay(interval.rawValue, viewModel.calculateAverage(for: date, category: timespan, interval: interval))
                    .hidden(intervalHidden[interval] ?? false)
                    .animation(.default, value: intervalHidden[interval])
                    .transition(.move(edge: .trailing))
            }
            
            Spacer()
            
            switch timespan {
            case .alltime: DatePickerView($date, from: model.startingID, to: Date())
            case .thismonth: MonthPicker(date: $date, from: model.startingID, to: Date())
            case .thisweek: DatePickerView($date, from: model.startingID, to: Date())
            }
            
            CustomPicker($timespan)
            
            Spacer()
        }
    }
}

struct Averages_Previews: PreviewProvider {
    static var previews: some View {
        AverageView()
            .preview()
    }
}
