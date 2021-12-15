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
<<<<<<< HEAD
    @StateObject var model = AshtrayModel()
    @StateObject var viewModel = AshtrayViewModel()
    
    init() {
        UIScrollView.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
    }
=======
>>>>>>> parent of ab469f5 (Managed to get it working at least.)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
