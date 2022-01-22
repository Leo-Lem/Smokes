//
//  StartDatePicker.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 22.01.22.
//

import SwiftUI

extension PrefView.Content {
    struct StartDatePicker: View {
        @Binding var date: Date
        
        var body: some View {
            HStack {
                Text("pref-start-date-label")
                DatePicker($date, to: Date())
            }
            .padding(.vertical, 5)
        }
    }
}

//MARK: - Previews
struct PrefViewStartDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        PrefView.Content.StartDatePicker(date: .constant(Date()))
    }
}
