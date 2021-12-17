//
//  AshtrayCoreDataApp.swift
//  AshtrayCoreData
//
//  Created by Leopold Lemmermann on 12.12.21.
//

import SwiftUI

@main
struct AshtrayCoreDataApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var model = AshtrayModel()
    @StateObject var viewModel = AshtrayViewModel()
    
    init() {
        UIScrollView.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
