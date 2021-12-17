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
    @EnvironmentObject private var viewModel: AshtrayViewModel
    @Environment(\.managedObjectContext) private var moc
    
    @State private var date = Date()
    @State private var isEditing = false
    
    var body: some View {
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
                    }
                }
            }
            
            Spacer()
        }
    }
    
    private func addCig() {
        print(model.counts)
        //TODO: Add cigarettes to coredata
        /*if model.counts[getID(date)] != nil { model.counts[getID(date)]! += 1 }
        else { model.counts[getID(date)] = 1 }*/
    }
    
    private func remCig() {
        //TODO: remove cigarettes from coredata
        /*if model.counts[getID(date)] ?? 0 > 0 { model.counts[getID(date)]! -= 1 }*/
    }
}

struct EditCigs_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .preview()
    }
}
