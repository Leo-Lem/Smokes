//
//  TitleBar.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI
import MyCustomUI

extension AshtrayView {
    struct TitleBar: ViewModifier {
        @Binding var selectedOverlay: Overlay
        
        func body(content: Content) -> some View {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        SymbolButton("pref-button-symbol"~) { selectedOverlay = .pref }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("app-title"~).font("default-font"~)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SymbolButton("info-button-symbol"~) { selectedOverlay = .info }
                    }
                }
                .embedInNavigation()
        }
    }
}

//MARK: - Previews
struct TitleBar_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World!")
            .modifier(AshtrayView.TitleBar(selectedOverlay: .constant(.none)))
    }
}
