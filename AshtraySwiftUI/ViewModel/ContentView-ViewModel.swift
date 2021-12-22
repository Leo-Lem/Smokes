//
//  ContentView-ViewModel.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.12.21.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: SuperViewModel {
        enum ViewType: String, CaseIterable {
            case main = "Ashtray", history = "History", average = "Average"
        }
        
        @Published var selectedView: ViewType = .main
        @Published var showOverlay = false
        @Published var showInfo = false
    }
}
