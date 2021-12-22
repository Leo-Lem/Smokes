//
//  EditCigs.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.07.21.
//

import SwiftUI
import MyCustomUI

struct HistoryView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ForEach(ViewModel.DisplayCategory.allCases, id: \.self) { category in
                CountDisplay(category.rawValue, viewModel.getDiplayValue(category: category))
                    .layoutListItem()
                    .onTapGesture {} //making scrolling possible with the longpressgesture recognizer
                    .onLongPressGesture(minimumDuration: 1) {
                        withAnimation { viewModel.isEditing = true }
                    }
                    .opacity(viewModel.isEditing ? 0.8 : 1)
                    .animation(viewModel.isEditing ? .linear(duration: 1).repeatForever() : .default, value: viewModel.isEditing)
            }
            
            Spacer()
            
            DatePicker($viewModel.date, from: viewModel.startingDate)
                .labelsHidden()
                .layoutListItem()
            
            TwoWayDragButton(leftAction: removeCig, rightAction: addCig)
                .transition(.move(edge: .bottom))
                .hidden(!viewModel.isEditing)
            
            Spacer()
        }
        .overlay(alignment: .bottomTrailing) {
            SymbolButton("xmark.circle") {
                withAnimation { viewModel.isEditing = false }
            }
            .hidden(!viewModel.isEditing)
        }
    }
    
    private func addCig() { viewModel.addCig() }
    private func removeCig() { viewModel.removeCig() }
}

struct EditCigs_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .preview()
    }
}
