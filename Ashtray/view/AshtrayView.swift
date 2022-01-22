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
                        .tabItem { Label("history-label"~, systemImage: "history-label-symbol"~) }
                        .tag(Page.hist)
                    MainView()
                        .tabItem { Label("main-label"~, systemImage: "main-label-symbol"~) }
                        .tag(Page.main)
                    StatView()
                        .tabItem { Label("stats-label"~, systemImage: "stats-label-symbol"~)}
                        .tag(Page.stat)
                }
                .padding(.bottom, 50)
            }
            .tabViewStyle(.page)
            .labelStyle(.iconOnly)
            .modifier(TitleBar(selectedOverlay: $currentOverlay))
            .backgroundImage("BackgroundImage", opacity: 0.6)
            .embedInNavigation()
        }
        .overlay {
            ZStack {
                if currentOverlay != .none {
                    Color.black.opacity(0.8).ignoresSafeArea()
                    
                    Group {
                        if currentOverlay == .pref { PrefView() }
                        else if currentOverlay == .info { InfoView() }
                    }
                    .overlay(alignment: .bottom) {
                        SymbolButton("dismiss-overlay-symbol"~) { currentOverlay = .none }
                        .font(size: 30)
                    }
                    .transition(.move(edge: .top))
                }
            }
            .animation(currentOverlay)
        }
        .foregroundColor(.primary)
    }
    
    @State private var currentOverlay: Overlay = .none
    @State private var currentPage: Page = .main
    
    enum Page { case main, hist, stat }
    enum Overlay { case none, pref, info }
}

//MARK: - Previews
struct AshtrayView_Previews: PreviewProvider {
    static var previews: some View {
        AshtrayView()
    }
}
