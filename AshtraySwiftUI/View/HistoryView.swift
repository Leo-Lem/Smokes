//
//  EditCigs.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.07.21.
//

import SwiftUI
import MyCustomUI

struct HistoryView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ForEach(ViewModel.DisplayCategory.allCases, id: \.self) { category in
                CountDisplay(category.rawValue, viewModel.getDiplayValue(category: category))
                    .layoutListItem()
                    .onTapGesture {} //making scrolling possible with the longpressgesture recognizer
                    .onLongPressGesture(minimumDuration: 1) {
                        withAnimation { viewModel.editing.isEditing = true }
                    }
                    .opacity(viewModel.editing.opacity)
                    .animation(viewModel.editing.animation, value: viewModel.editing.isEditing)
            }
            
            Spacer()
            
            DatePicker($viewModel.date, from: viewModel.startingDate)
                .labelsHidden()
                .layoutListItem()
            
            TwoWayDragButton(leftAction: removeCig, rightAction: addCig)
                .transition(.move(edge: .bottom))
                .hidden(!viewModel.editing.isEditing)
            
            Spacer()
        }
        .overlay(alignment: .bottomTrailing) {
            SymbolButton("xmark.circle") {
                withAnimation { viewModel.editing.isEditing = false }
            }
            .hidden(!viewModel.editing.isEditing)
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
