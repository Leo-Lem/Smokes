//
//  AshtrayView.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI
import MyCustomUI

struct AshtrayView: View {
    var body: some View {
        Group {
            TabView(selection: $currentPage) {
                Group {
                    HistView()
                        .tabItem { Label("history-label-text"~, systemImage: "history-label-symbol"~) }
                        .tag(Page.hist)
                    MainView()
                        .tabItem { Label("main-label-text"~, systemImage: "main-label-symbol"~) }
                        .tag(Page.main)
                    StatView()
                        .tabItem { Label("stats-label-text"~, systemImage: "stats-label-symbol"~)}
                        .tag(Page.stat)
                }
                .padding(.bottom, 25)
            }
            .tabViewStyle(.page)
            .labelStyle(.iconOnly)
            .modifier(TitleBar(selectedOverlay: $currentOverlay))
        }
        .overlay {
            switch currentOverlay {
            case .pref:
                PrefView()
                    .overlay(alignment: .bottom) {
                        SymbolButton("dismiss-overlay-symbol"~) { currentOverlay = .none }
                    }
            case .info:
                InfoView()
                    .overlay(alignment: .bottom) {
                        SymbolButton("dismiss-overlay-symbol"~) { currentOverlay = .none }
                    }
            default: EmptyView()
            }
        }
        .foregroundColor(.primary)
    }
    
    @State private var currentOverlay: Overlay = .none
    @State private var currentPage: Page = .main
}

extension AshtrayView {
    enum Page { case main, hist, stat }
    enum Overlay { case none, pref, info }
}

//MARK: - Previews
struct AshtrayView_Previews: PreviewProvider {
    static var previews: some View {
        AshtrayView()
    }
}
