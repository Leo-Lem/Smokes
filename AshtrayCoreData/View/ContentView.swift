//
//  ContentView.swift
//  AshtrayCoreData
//
//  Created by Leopold Lemmermann on 12.12.21.
//

import SwiftUI
import AshtrayLogic

struct ContentView: View {
<<<<<<< HEAD
    @EnvironmentObject private var model: AshtrayModel
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(entity: Count.entity(), sortDescriptors: []) var fetchedCounts: FetchedResults<Count> {
        didSet {
            model.counts = CountCollectionType(fetchedCounts)
        }
    }
    
    @State private var selectedView: ViewType = .main
    @State private var showSettings = false
=======
>>>>>>> parent of ab469f5 (Managed to get it working at least.)
    @State private var showInfo = false
    @State private var showSettings = false
    var showButtons: Bool { selectedView == .main }
    
    init() {
        UIScrollView.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
                ZStack {
                    VStack {
                        TitleView(selectedView.rawValue, showButtons: showButtons, showSettings: $showSettings, showInfo: $showInfo).zIndex(2)
                        TabView(selection: $selectedView) {
                            HistoryView().tabItem { Image("symbol.history") }.tag(ViewType.hist)
                            MainView().tabItem { Image("symbol.ashtray") }.tag(ViewType.main)
                            AverageView().tabItem { Image("symbol.average") }.tag(ViewType.avg)
                        }.tabViewStyle(.page)
                        .environment(\.currentView, selectedView)
                        .zIndex(1)
                    }
                    
                    Group {
                        if showInfo || showSettings { Color.black.opacity(0.5).ignoresSafeArea() }
                        if showSettings { SettingsView(showSettings: $showSettings).transition(.move(edge: .top)) }
                        if showInfo { InfoView(showInfo: $showInfo).transition(.move(edge: .top)) }
                    }.zIndex(2)
                }
                .navigationBarHidden(true)
                .backgroundImage()
                .environmentObject(model)
            }
<<<<<<< HEAD
            
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
=======
>>>>>>> parent of ab469f5 (Managed to get it working at least.)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
