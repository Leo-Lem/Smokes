//
//  EditCigs.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.07.21.
//

import SwiftUI
import MyCustomUI

struct HistoryView: View {
    @EnvironmentObject private var viewModel: AshtrayViewModel
    
    @State private var date = Date()
    @State private var editing = Editing()
    
    var body: some View {
        VStack {
            ForEach(AshtrayViewModel.History.allCases, id: \.self) { category in
                CountDisplay(category.rawValue, viewModel.calculateHistory(for: date, category: category))
                    .layoutListItem()
                    .onTapGesture {} //making scrolling possible with the longpressgesture recognizer
                    .onLongPressGesture(minimumDuration: 1) {
                        withAnimation {
                            editing.isEditing = true
                        }
                    }
                    .opacity(editing.opacity)
                    .animation(editing.animation, value: editing.isEditing)
            }
            
            Spacer()
            
            DatePicker($date, from: viewModel.startingID)
                .labelsHidden()
                .layoutListItem()
            
            TwoWayDragButton(leftAction: removeCig,
                             rightAction: addCig)
                .transition(.move(edge: .bottom))
                .hidden(!editing.isEditing)
            
            Spacer()
        }
        .overlay(alignment: .bottomTrailing) {
            SymbolButton("xmark.circle") {
                withAnimation {
                    editing.isEditing = false
                }
            }
            .hidden(!editing.isEditing)
        }
    }
    
    private func addCig() {
        viewModel.addCig(on: date)
    }
    
    private func removeCig() {
        viewModel.removeCig(on: date)
    }
    
    private struct Editing {
        var isEditing: Bool = false {
            didSet {
                if isEditing == true {
                    opacity = 0.8
                } else {
                    opacity = 1
                }
            }
        }
        var opacity: CGFloat = 1
        var animation: Animation {
            if isEditing {
                return Animation.easeInOut(duration: 1)
                    .repeatForever()
            } else {
                return Animation.easeInOut
            }
        }
    }
}

struct EditCigs_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .preview()
    }
}
