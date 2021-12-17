//
//  TitleView.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 11.10.21.
//

import SwiftUI
import MyLayout
import MyCustomUI

struct TitleView: View {
    @Binding var showInfo: Bool; @Binding var showSettings: Bool
    let title: String, buttonSize: CGFloat, height: CGFloat
    
    init(_ title: String, showSettings: Binding<Bool>, showInfo: Binding<Bool>,
         buttonSize: CGFloat = LayoutDefaults().symbolButtonSize,
         height: CGFloat = LayoutDefaults().rowHeight) {
        self.title = title
        self._showInfo = showInfo
        self._showSettings = showSettings
        self.buttonSize = buttonSize
        self.height = height
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            ZStack(alignment: .trailing) {
                Text(title)
                    .font()
                    .frame(maxWidth: .infinity)
                
                SymbolButton("info.circle") {
                    withAnimation {
                        showInfo = true
                    }
                }
                .padding(5)
            }
            
            SymbolButton("gear.circle") {
                withAnimation {
                    showSettings = true
                }
            }
            .padding(5)
        }
        .frame(maxHeight: height)
        .customBackground()
        .padding(.horizontal)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView("Title", showSettings: .constant(false), showInfo: .constant(false))
            .preview()
    }
}
