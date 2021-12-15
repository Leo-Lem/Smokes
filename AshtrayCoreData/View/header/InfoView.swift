//
//  InfoView.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 12.10.21.
//

import SwiftUI
import MyCustomUI

struct InfoView: View {
    @Binding var showInfo: Bool
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                Section(header: Text("info").font(size: 15).customBackground()) {
                    Text("Hi, my name's Leo. Ashtray has been my project for a while now. It started out as something I was missing on my iPhone: A way to gain insight into my smoking habit. I had pretty much just started out learning to program for iOS and this was a great project to practice my skills on.").font(size: 15).multilineTextAlignment(.center).padding(5)
                }.customRowBackground()
                
                Section(header: Text("credits").font(size: 15).customBackground()) {
                    Text("App Design by Leopold Lemmermann\nArtwork by").font(size: 15).padding(5)
                }.customRowBackground()
            }
<<<<<<< HEAD
            SymbolButton("xmark.circle") {
                withAnimation {
                    showInfo = false
                }
            }
            .padding(5)
=======
            SymbolButtonView("xmark.circle") { withAnimation { showInfo = false } }
                .padding(5)
>>>>>>> parent of ab469f5 (Managed to get it working at least.)
        }
    }
}

extension InfoView {
    init(_ showInfo: Binding<Bool>) {
        self._showInfo = showInfo
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(.constant(true)).preview()
    }
}
