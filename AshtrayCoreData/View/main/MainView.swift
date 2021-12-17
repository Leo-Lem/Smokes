//
//  ContentView.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 18.07.21.
//

import SwiftUI
import MyCustomUI

struct MainView: View {
    @EnvironmentObject private var model: AshtrayModel
    @EnvironmentObject private var viewModel: AshtrayViewModel
    @Environment(\.managedObjectContext) private var moc
    
    var body: some View {
            VStack {
                ForEach(CountCategories.Main.allCases, id:\.self) { category in
                    NavigationLink {
                        //TODO: insert plots to visualize different counts
                    } label: {
                        CountDisplay(category.rawValue, viewModel.calculateMain(category: category))
                    }
                }
                
                Spacer()
                
                TwoWayDragButton(symbols: ["circle"], leftAction: remCig, rightAction: addCig)
                
                Spacer()
            }
    }
    
    private func addCig() {
        print(model.counts)
        //TODO: add cigarettes to coredata model
    }
    
    private func remCig() {
        //TODO: remove cigarettes to coredata model
        /*if model.counts[getID(date)] ?? 0 > 0 { model.counts[getID(date)]! -= 1 }*/
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
