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
        let calc: (Total) -> Int, add: (Date) -> Void, rem: (Date) -> Void
        
        var body: some View {
            VStack {
                ForEach(Total.histCases(date), id:\.self) { total in
                    //NavigationLink {
                        //TODO: insert plots to visualize different counts
                    //} label: {
                        LabeledNumber(label: total.histName, number: calc(total))
                            .rowItem().frame(maxHeight: 100)
                            .onTapGesture {} //making scrolling possible with the longpressgesture recognizer
                            .onLongPressGesture { editing.toggle() }
                            .opacity(editing ? 0.8 : 1)
                            .animation(editing ? .linear(duration: 1).repeatForever() : .default, value: editing)
                    //}
                }
                
                Spacer()
                
                CustomDatePicker(.regular, date: $date, from: startDate)
                    .rowItem()
                
                TwoWayDragButton(left: { rem(date) }, right: { add(date) })
                    .font(size: 70)
                    .hidden(!editing)
                
                Spacer()
            }
            .animation(editing)
        }
        
        @State private var date = Date()
        @State private var editing = false
    }
}

//MARK: - Previews
struct HistViewContent_Previews: PreviewProvider {
    static var previews: some View {
        HistView.Content(startDate: Date(), calc: { _ in 0}, add: {_ in}, rem: {_ in})
    }
}

extension HistView.Content {
    #if DEBUG
    typealias Total = StateController.Total
    #endif
}
