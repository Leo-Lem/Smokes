//
//  Row.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI

extension MainView.Content {
    struct LabeledNumber<N: CustomStringConvertible>: View {
        let label: String, number: N
        
        var body: some View {
            GeometryReader { geo in
                HStack {
                    Text(label)
                    
                    Spacer()
                    Divider()
                    
                    Text("\(number.description)")
                        .frame(width: geo.size.width / 4)
                }
            }
        }
    }
}

extension HistView.Content { typealias LabeledNumber = MainView.Content.LabeledNumber }
extension StatView.Content { typealias LabeledNumber = MainView.Content.LabeledNumber }

//MARK: - Previews
struct Row_Previews: PreviewProvider {
    static var previews: some View {
        MainView.Content.LabeledNumber(label: "today", number: 10)
            .frame(maxHeight: 75)
    }
}
