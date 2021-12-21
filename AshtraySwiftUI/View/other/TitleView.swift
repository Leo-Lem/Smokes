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
    @Binding var showOverlay: Bool; @Binding var showInfo: Bool
    let title: String, buttonSize: CGFloat, height: CGFloat
    
    init(_ title: String, showOverlay: Binding<Bool>, showInfo: Binding<Bool>,
         buttonSize: CGFloat = LayoutDefaults.symbolButtonSize,
         height: CGFloat = LayoutDefaults.rowHeight) {
        self.title = title
        self._showOverlay = showOverlay
        self._showInfo = showInfo
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
                        showOverlay = true
                    }
                }
                .padding(5)
            }
            
            SymbolButton("gear.circle") {
                withAnimation {
                    showInfo = false
                    showOverlay = true
                }
            }
            .padding(5)
        }
        .frame(maxHeight: height)
        .layoutListItem()
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView("Title", showOverlay: .constant(false), showInfo: .constant(false))
            .preview()
    }
}
