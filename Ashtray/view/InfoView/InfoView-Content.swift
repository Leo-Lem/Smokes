//
//  Content.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI
import MyCustomUI

extension InfoView {
    struct Content: View {
        var body: some View {
            VStack {
                Text("info-label"~).font("default-font"~, size: 30)
                
                Section {
                    Text("info-text"~)
                        .font(size: 15, padd: false)
                        .multilineTextAlignment(.center)
                        .rowItem()
                }
                
                Section("credits-label"~) {
                    Text("credits-text"~)
                        .font(size: 15)
                        .rowItem()
                }
                
                Spacer()
            }
        }
    }
}

//MARK: - Previews
struct InfoViewContent_Previews: PreviewProvider {
    static var previews: some View {
        InfoView.Content()
    }
}
