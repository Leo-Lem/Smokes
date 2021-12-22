//
//  ContentView.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 18.07.21.
//

import SwiftUI
import MyCustomUI

struct MainView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ForEach(ViewModel.DisplayCategory.allCases, id:\.self) { category in
                NavigationLink {
                    //TODO: insert plots to visualize different counts
                } label: {
                    CountDisplay(category.rawValue, viewModel.getDiplayValue(category: category))
                        .layoutListItem()
                }
            }
            
            Spacer()
            
            TwoWayDragButton(leftAction: removeCig, rightAction: addCig)
            
            Spacer()
        }
    }
    
    private func removeCig() { viewModel.removeCig() }
    private func addCig() { viewModel.addCig() }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView()
                .preview()
        }
    }
}
