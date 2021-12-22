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
                TitleView(viewModel.selectedView.rawValue, showOverlay: $viewModel.showOverlay, showInfo: $viewModel.showInfo)
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
            .overlay {
                if viewModel.showOverlay {
                    Color.black.opacity(0.5).ignoresSafeArea()
                }
            }
            
            if viewModel.showOverlay {
                Group {
                    if viewModel.showInfo {
                        InfoView()
                            .transition(.move(edge: .top))
                    } else {
                        SettingsView()
                            .transition(.move(edge: .top))
                    }
                }
                .overlay(alignment: .bottom) {
                    SymbolButton("chevron.up", size: 40) {
                        withAnimation {
                            viewModel.showOverlay = false
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
