//
//  Content.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI
import MyCustomUI

extension HistView {
    struct Content: View {
        let startDate: Date
        let calc: (Date) async -> [Total: Int], add: (Date) -> Void, rem: (Date) -> Void
        
        var body: some View {
            VStack {
                ForEach(Total.histCases(date), id:\.self) { total in
                    //NavigationLink {
                        //TODO: insert plots to visualize different counts
                    //} label: {
                    LabeledNumber(label: total.histName, number: amounts[total] != nil ? String(amounts[total]!) : "...")
                        .rowItem().frame(maxHeight: 100)
                        .onTapGesture {} //making scrolling possible with the longpressgesture recognizer
                        .onLongPressGesture { editing.toggle() }
                        .opacity(editing ? 0.8 : 1)
                        .animation(editing ? .linear(duration: 1).repeatForever() : .default, value: editing)
                    //}
                }
                .task { amounts = await calc(date) }
                //TODO: add a cache so the values don't always have to be recalculated when the timespan changes
                
                Spacer()
                
                CustomDatePicker(.regular, date: $date, from: startDate)
                    .rowItem()
                
                TwoWayDragButton(left: {
                    rem(date)
                    Task { amounts = await calc(date) }
                }, right: {
                    add(date)
                    Task { amounts = await calc(date) }
                })
                    .font(size: 70)
                    .hidden(!editing)
                    .transition(.offset(y: 400))
                
                Spacer()
            }
            .onDisappear { editing = false }
            .animation(editing)
            .animation(amounts)
        }
        
        @State private var date = Date()
        @State private var editing = false
        @State private var amounts = [Total: Int]()
    }
}

//MARK: - Previews
struct HistViewContent_Previews: PreviewProvider {
    static var previews: some View {
        HistView.Content(startDate: Date(), calc: { _ in [:]}, add: {_ in}, rem: {_ in})
    }
}

extension HistView.Content {
    #if DEBUG
    typealias Total = StateController.Total
    #endif
}
