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
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                TitleView(viewModel.selectedView.rawValue, selectedOverlay: $viewModel.selectedOverlay)
                    .zIndex(2)
                TabView(selection: $viewModel.selectedView) {
                    HistoryView()
                        .tag(ViewModel.ViewType.history)
                    MainView()
                        .tag(ViewModel.ViewType.main)
                    AverageView()
                        .tag(ViewModel.ViewType.average)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .zIndex(1)
            }
            .accessibilityHidden(viewModel.selectedOverlay != .none)
            .overlay {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .hidden(viewModel.selectedOverlay == .none)
            }
            
            Group {
                SettingsView()
                    .hidden(viewModel.selectedOverlay != .settings)
                
                InfoView()
                    .hidden(viewModel.selectedOverlay != .info)
            }
            .transition(.move(edge: .top))
            .overlay(alignment: .bottom) {
                SymbolButton("chevron.up", size: 40) {
                    withAnimation { viewModel.selectedOverlay = .none }
                }
                .accessibilityLabel("Dismiss")
            }
            .zIndex(3)
            .hidden(viewModel.selectedOverlay == .none)
        }
        .backgroundImage("BackgroundImage", opacity: 0.9)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
