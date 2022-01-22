//
//  Content.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI
import MyCustomUI

extension PrefView {
    struct Content: View {
        let edit: (Date) -> Void
        
        var body: some View {
            VStack {
                Section {
                    StartDatePicker(date: $startDate)
                        .rowItem()
                        .onChange(of: startDate, perform: edit)
                }
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .principal) { Text("prefs-label"~).font(.title) }
            }
            .embedInNavigation()
            .blendMode(.lighten) //TODO: check if the background of the navView can be made transparent in less of a work-around
        }
        
        @State private var startDate: Date
        init(startDate: Date, edit: @escaping (Date) -> Void) {
            self._startDate = State(initialValue: startDate)
            self.edit = edit
        }
    }
}

//MARK: - Previews
struct PrefViewContent_Previews: PreviewProvider {
    static var previews: some View {
        PrefView.Content(startDate: Date(), edit: {_ in})
    }
}
