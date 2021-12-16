//
//  ContentView.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 18.07.21.
//

import SwiftUI
import MyCustomUI

struct MainView: View {
    @EnvironmentObject private var viewModel: AshtrayViewModel
    
    var body: some View {
        VStack {
            ForEach(AshtrayViewModel.Main.allCases, id:\.self) { category in
                NavigationLink {
                    //TODO: insert plots to visualize different counts
                } label: {
                    CountDisplay(category.rawValue, viewModel.calculateMain(category: category))
                        .layoutListItem()
                }
            }
            
            Spacer()
            
            TwoWayDragButton(leftAction: removeCig,
                             rightAction: addCig)
            
            Spacer()
        }
    }
    
    private func addCig() {
        viewModel.addCig()
    }
    
    private func removeCig() {
        viewModel.removeCig()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView()
                .preview()
        }
    }
}
