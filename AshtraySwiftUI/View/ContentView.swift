//
//  ContentView.swift
//  AshtrayCoreData
//
//  Created by Leopold Lemmermann on 12.12.21.
//

import SwiftUI
import MyLayout
import MyCustomUI

struct ContentView: View {
    private enum ViewType: String, CaseIterable {
        case main = "Ashtray", history = "History", average = "Average"
    }
    @State private var selectedView: ViewType = .main
    @State private var showOverlay = false
    @State private var showInfo = false
    
    var body: some View {
        ZStack {
            VStack {
                TitleView(selectedView.rawValue, showOverlay: $showOverlay, showInfo: $showInfo)
                    .zIndex(2)
                TabView(selection: $selectedView) {
                    HistoryView()
                        .tag(ViewType.history)
                    MainView()
                        .tag(ViewType.main)
                    AverageView()
                        .tag(ViewType.average)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .zIndex(1)
            }
            
            if showOverlay {
                Group {
                    if showInfo {
                        InfoView()
                            .transition(.move(edge: .top))
                    } else {
                        SettingsView()
                            .transition(.move(edge: .top))
                    }
                }
                .background {
                    Color.black
                        .opacity(0.5)
                        .ignoresSafeArea()
                }
                .overlay(alignment: .bottomTrailing) {
                    SymbolButton("xmark.circle") {
                        withAnimation {
                            showOverlay = false
                        }
                    }
                    .padding(5)
                }
                .zIndex(3)
            }
        }
        .backgroundImage("BackgroundImage", opacity: 0.8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preview()
    }
}
