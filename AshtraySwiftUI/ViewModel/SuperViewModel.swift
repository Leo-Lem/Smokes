//
//  ViewModel.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 21.12.21.
//

import Foundation
import Combine
import MyOthers

class SuperViewModel: ObservableObject {
    let model = Model()
    private var observer: AnyCancellable?
    
    init() {
        self.observer = model.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
    }
    
    var startingDate: Date {
        get { model.startingID.getDate() }
        set { model.startingID = Count.getID(from: newValue)}
    }
    
}
