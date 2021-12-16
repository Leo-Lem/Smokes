//
//  AshtraySwiftUIApp.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 18.07.21.
//

import SwiftUI

@main
struct AshtraySwiftUIApp: App {
    @StateObject var viewModel = AshtrayViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
