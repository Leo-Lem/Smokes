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
    private typealias Overlay = ContentView.ViewModel.OverlayType
    @Binding private var selectedOverlay: Overlay
    let title: String, buttonSize: CGFloat, height: CGFloat
    
    init(_ title: String,
         selectedOverlay: Binding<ContentView.ViewModel.OverlayType>,
         buttonSize: CGFloat = LayoutDefaults.symbolButtonSize,
         height: CGFloat = LayoutDefaults.rowHeight) {
        self.title = title
        self._selectedOverlay = selectedOverlay
        self.buttonSize = buttonSize
        self.height = height
    }
    
    var body: some View {
        Text(title)
            .font()
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                SymbolButton("gear.circle", size: buttonSize) {
                    withAnimation { selectedOverlay = .settings }
                }
                .padding(5)
                .accessibilityLabel(Overlay.settings.rawValue)
            }
            .overlay(alignment: .trailing) {
                SymbolButton("info.circle", size: buttonSize) {
                    withAnimation { selectedOverlay = .info }
                }
                .padding(5)
                .accessibilityLabel( Overlay.info.rawValue )
            }
            .frame(maxHeight: height)
            .layoutListItem()
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView("Title", selectedOverlay: .constant(.none))
    }
}
