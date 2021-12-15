//
//  EditCigs.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.07.21.
//

import SwiftUI
import MyCustomUI

struct HistoryView: View {
    @EnvironmentObject private var model: AshtrayModel
<<<<<<< HEAD
    @EnvironmentObject private var viewModel: AshtrayViewModel
    @Environment(\.managedObjectContext) private var moc
=======
    @Namespace var namespace
>>>>>>> parent of ab469f5 (Managed to get it working at least.)
    
    @State private var date = Date()
    @State private var isEditing = false
    
    var body: some View {
<<<<<<< HEAD
        VStack {
            ForEach(CountCategories.History.allCases, id: \.self) { category in
                CountDisplay(category.rawValue, viewModel.calculateHistory(for: date, category: category))
            }
            
            Spacer()
            
            DatePickerView($date, from: model.startingID)
            
            ZStack(alignment: .bottom) {
                if isEditing {
                    VStack(spacing: 0) {
                        TwoWayDragButton(leftAction: addCig, rightAction: remCig)
                        SymbolButton("chevron.down", size: 40) {
                            withAnimation {
                                isEditing = false
                            }
                        }
                    }
                }
                else {
                    SymbolButton("chevron.up", size: 40) {
                        withAnimation {
                            isEditing = true
                        }
=======
        GeometryReader { geo in
            VStack {
                ForEach(HistoryCountType.allCases, id: \.self) { type in
                    CounterView(type.rawValue, model.calcHist(date, from: model.counts, type: type))
                }
                Spacer()
                DatePickerView($date, from: model.installationDate)
                ZStack(alignment: .bottom) {
                    if isEditing {
                        SymbolButtonView("chevron.down", size: 40) { isEditing = false }
                        TwoWayDragButton(leftAction: addCig, rightAction: remCig)
                            .transition(.offset(y: geo.size.height/3))
>>>>>>> parent of ab469f5 (Managed to get it working at least.)
                    }
                    else { SymbolButtonView("chevron.up", size: 40) { isEditing = true } }
                }
                Spacer().frame(height: geo.size.height / 10)
            }.environment(\.animateCounts, isEditing)
        }
    }
}

extension HistoryView {
    private func addCig() {
        if model.counts[getID(date)] != nil { model.counts[getID(date)]! += 1 }
        else { model.counts[getID(date)] = 1 }
    }
    
    private func remCig() {
        if model.counts[getID(date)] ?? 0 > 0 { model.counts[getID(date)]! -= 1 }
    }
    
    private func addPack() {
        if model.packs[getID(date)] != nil { model.packs[getID(date)]! += 1 }
        else { model.packs[getID(date)] = 1 }
    }
    
    private func remPack() {
        if model.packs[getID(date)] ?? 0 > 0 { model.packs[getID(date)]! -= 1 }
    }
}

struct EditCigs_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().preview()
    }
}
