//
//  AshtrayApp.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 17.01.22.
//

import SwiftUI

@main
struct AshtrayApp: App {
    let stateController = StateController()
    
    var body: some Scene {
        WindowGroup {
            AshtrayView()
                .environmentObject(stateController)
        }
    }
}
