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
    
    @State private var timespan: AvgTimespanType = .at
    @State private var date = Date()
    private var showAvg: [AvgIntervalType: Bool] { [.dly: true, .wly: timespan == .at || timespan == .mt, .mly: timespan == .at] }
    
    var body: some View {
<<<<<<< HEAD
        VStack {
            ForEach(CountCategories.Average.Interval.allCases, id:\.self) { interval in
                CountDisplay(interval.rawValue, viewModel.calculateAverage(for: date, category: timespan, interval: interval))
                    .hidden(intervalHidden[interval] ?? false)
                    .animation(.default, value: intervalHidden[interval])
                    .transition(.move(edge: .trailing))
=======
        GeometryReader { geo in
            VStack {
                ForEach(AvgIntervalType.allCases, id:\.self) { type in
                    CounterView(type.rawValue, model.calcAvg(date, from: model.counts, timespan: timespan, interval: type))
                        .hidden(showAvg[type]!).transition(.move(edge: .trailing))
                }
                Spacer()
                switch timespan {
                case .at: DatePickerView($date, from: model.installationDate, to: Date())
                case .mt: MonthPicker(date: $date, from: model.installationDate, to: Date())
                case .wk: DatePickerView($date, from: model.installationDate, to: Date())
                }
                
                CustomPicker($timespan)
                Spacer().frame(height: geo.size.height / 10)
>>>>>>> parent of ab469f5 (Managed to get it working at least.)
            }
        }
    }
}

struct Averages_Previews: PreviewProvider {
    static var previews: some View {
        AverageView().preview()
    }
}
