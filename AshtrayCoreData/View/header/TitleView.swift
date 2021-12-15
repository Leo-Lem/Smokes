//
//  TitleView.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 11.10.21.
//

import SwiftUI
import MyCustomUI

struct TitleView: View {
    @Binding var showInfo: Bool; @Binding var showSettings: Bool
    let title: String, showButtons: Bool
    let buttonSize: CGFloat, height: CGFloat
    
    var body: some View {
        ZStack(alignment: .leading) {
            ZStack(alignment: .trailing) {
<<<<<<< HEAD
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
=======
                Text(title).font().frame(maxWidth: .infinity)
                SymbolButtonView("info.circle") { withAnimation { showInfo = true } }
                    .padding(5).hidden(showButtons)
            }
            SymbolButtonView("gear.circle") { withAnimation { showSettings = true } }
                .padding(5).hidden(showButtons)
        }.frame(maxHeight: height).customBackground().padding(.horizontal)
    }
}

extension TitleView {
    init(_ title: String, showButtons: Bool = false, showSettings: Binding<Bool>, showInfo: Binding<Bool>, buttonSize: CGFloat = 30, height: CGFloat = 30) {
        self.title = title; self.showButtons = showButtons
        self._showInfo = showInfo; self._showSettings = showSettings
        self.buttonSize = buttonSize; self.height = height
>>>>>>> parent of ab469f5 (Managed to get it working at least.)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView("Title", showButtons: true, showSettings: .constant(false), showInfo: .constant(false))
    }
}
