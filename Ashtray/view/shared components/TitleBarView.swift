//
//  TitleBar.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI
import MyCustomUI

extension AshtrayView {
    struct TitleBarView: View {
        @Binding var selectedOverlay: Overlay
        
        var body: some View {
            HStack {
                SymbolButton("pref-button-symbol"~) { selectedOverlay = .pref }
                
                Spacer()
                
                Text("app-title"~).hidden(selectedOverlay != .none )
                
                Spacer()
                
                SymbolButton("info-button-symbol"~) { selectedOverlay = .info }
            }
        }
    }
}

//MARK: - Previews
struct TitleBar_Previews: PreviewProvider {
    static var previews: some View {
        AshtrayView.TitleBarView(selectedOverlay: .constant(.none))
    }
}
