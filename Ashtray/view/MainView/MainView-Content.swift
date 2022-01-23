//
//  Content.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI
import MyCustomUI

extension MainView {
    struct Content: View {
        let calc: () async -> [Total: Int], add: () -> Void, rem: () -> Void
        
        var body: some View {
            VStack {
                ForEach(Total.mainCases, id:\.self) { total in
                    //NavigationLink {
                        //TODO: insert plots to visualize different counts
                    //} label: {
                    LabeledNumber(label: total.mainName, number: amounts[total] ?? 0)
                        .rowItem().frame(maxHeight: 100)
                    //}
                }
                .task { amounts = await calc() }
                
                Spacer()
                
                TwoWayDragButton(left: {
                    rem()
                    Task { amounts = await calc() }
                }, right: {
                    add()
                    Task { amounts = await calc() }
                })
                .font(size: 70)
                
                Spacer()
            }
            .animation(amounts)
        }
        
        @State private var amounts = [Total: Int]()
    }
}

//MARK: - Previews
struct MainViewContent_Previews: PreviewProvider {
    static var previews: some View {
        MainView.Content(calc: {[:]}, add: {}, rem: {})
    }
}

extension MainView.Content {
    #if DEBUG
    typealias Total = StateController.Total
    #endif
}
