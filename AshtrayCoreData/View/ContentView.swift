//
//  ContentView.swift
//  AshtrayCoreData
//
//  Created by Leopold Lemmermann on 12.12.21.
//

import SwiftUI
import MyLayout

enum ViewType: String, CaseIterable {
    case main = "Ashtray", history = "History", average = "Average"
}

struct ContentView: View {
    @EnvironmentObject private var model: AshtrayModel
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(entity: Count.entity(), sortDescriptors: []) var fetchedCounts: FetchedResults<Count> {
        didSet {
            model.counts = CountCollectionType(fetchedCounts)
        }
    }
    
    @State private var selectedView: ViewType = .main
    @State private var showSettings = false
    @State private var showInfo = false
    
    var body: some View {
        ZStack {
            VStack {
                TitleView(selectedView.rawValue, showSettings: $showSettings, showInfo: $showInfo)
                    .zIndex(2)
                TabView(selection: $selectedView) {
                    HistoryView()
                        .tabItem { Image("symbol.history") }
                        .tag(ViewType.history)
                    MainView()
                        .tabItem { Image("symbol.ashtray") }
                        .tag(ViewType.main)
                    AverageView()
                        .tabItem { Image("symbol.average") }
                        .tag(ViewType.average)
                }
                .tabViewStyle(.page)
                .zIndex(1)
            }
            
            //TODO: Add animation to settings and info view
            Group {
                if showInfo || showSettings {
                    Color.black
                        .opacity(0.5)
                        .ignoresSafeArea()
                }
                if showSettings {
                    SettingsView(showSettings: $showSettings)
                        .transition(.move(edge: .top))
                }
                if showInfo {
                    InfoView(showInfo: $showInfo)
                        .transition(.move(edge: .top))
                }
            }
            .zIndex(3)
        }
        .backgroundImage("SmokingArea", opacity: 0.8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .preview()
    }
}
