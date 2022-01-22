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
        let calc: (Total) -> Int, add: () -> Void, rem: () -> Void
        
        var body: some View {
            VStack {
                ForEach(Total.mainCases, id:\.self) { total in
                    //NavigationLink {
                        //TODO: insert plots to visualize different counts
                    //} label: {
                        LabeledNumber(label: total.mainName, number: calc(total))
                            .rowItem().frame(maxHeight: 100)
                    //}
                }
                
                Spacer()
                
                TwoWayDragButton(left: rem, right: add)
                    .font(size: 70)
                
                Spacer()
            }
        }
    }
}

//MARK: - Previews
struct MainViewContent_Previews: PreviewProvider {
    static var previews: some View {
        MainView.Content(calc: { _ in 0}, add: {}, rem: {})
    }
}

extension MainView.Content {
    #if DEBUG
    typealias Total = StateController.Total
    typealias LabeledNumber = MainView.LabeledNumber
    #endif
}
