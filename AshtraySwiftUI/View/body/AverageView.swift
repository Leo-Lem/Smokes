//
//  Averages.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.07.21.
//

import SwiftUI
import MyLayout
import MyCustomUI

struct AverageView: View {
    @EnvironmentObject private var viewModel: AshtrayViewModel
    
    @State private var timespan: AshtrayViewModel.AverageSpan = .alltime
    @State private var date = Date()
    
    var body: some View {
        VStack {
            ForEach(AshtrayViewModel.AverageInterval.allCases, id:\.self) { interval in
                CountDisplay(interval.rawValue,
                             viewModel.calculateAverage(for: date, category: timespan, interval: interval))
                    .layoutListItem()
                    .hidden(interval.hideView(timespan))
                    .animation(.default, value: timespan)
                    .transition(.move(edge: .trailing))
            }
            
            Spacer()
            
            Group {
                switch timespan {
                case .alltime, .thisweek, .thismonth:
                    DatePicker($date, in: viewModel.startingID...Date())
                        .labelsHidden()
                        .layoutListItem()
                    
                //TODO: fix monthpicker
                //TODO: add custom weekpicker
                }
            }
            .frame(height: LayoutDefaults.rowHeight * 2)
            
            CustomPicker($timespan)
                .padding()
                .layoutListItem()
                
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
