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
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ForEach(ViewModel.Interval.allCases, id:\.self) { interval in
                CountDisplay(interval.rawValue, viewModel.getDisplayValue(interval: interval))
                    .layoutListItem()
                    .hidden(interval.hideView(viewModel.timespan))
                    .animation(.default, value: viewModel.timespan)
                    .transition(.move(edge: .trailing))
            }
            
            Spacer()
            
            Group {
                switch viewModel.timespan {
                case .alltime, .thisweek, .thismonth:
                    DatePicker($viewModel.date, in: viewModel.startingDate...Date())
                        .labelsHidden()
                        .layoutListItem()
                    
                //TODO: fix monthpicker
                //TODO: add custom weekpicker
                }
            }
            .frame(height: LayoutDefaults.rowHeight * 2)
            
            CustomPicker($viewModel.timespan)
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
