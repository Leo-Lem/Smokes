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
<<<<<<< HEAD
    @EnvironmentObject private var viewModel: AshtrayViewModel
    @Environment(\.managedObjectContext) private var moc
=======
    private let date = Date()
>>>>>>> parent of ab469f5 (Managed to get it working at least.)
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ForEach(CountType.allCases, id:\.self) { type in
                    NavigationLink(destination: {
                        VStack {
                            BarplotView(data: Array(model.counts.values), labels: Array(model.counts.keys))
                                .frame(maxHeight: geo.size.height / 3)
                        }
                    }){
                        CounterView(type.rawValue, model.calcMain(from: model.counts, type: type))
                    }
                }
                Spacer()
                TwoWayDragButton(symbols: ["circle"], leftAction: remCig, rightAction: addCig)
                Spacer().frame(height: geo.size.height / 10)
            }
        }
    }
}

extension MainView {
    private func addCig() {
<<<<<<< HEAD
        print(model.counts)
        //TODO: add cigarettes to coredata model
    }
    
    private func remCig() {
        //TODO: remove cigarettes to coredata model
        /*if model.counts[getID(date)] ?? 0 > 0 { model.counts[getID(date)]! -= 1 }*/
=======
        if model.counts[getID(date)] != nil { model.counts[getID(date)]! += 1 }
        else { model.counts[getID(date)] = 1 }
    }
    
    private func remCig() {
        if model.counts[getID(date)] ?? 0 > 0 { model.counts[getID(date)]! -= 1 }
>>>>>>> parent of ab469f5 (Managed to get it working at least.)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView().preview().navigationBarHidden(true)
        }
    }
}
