//
//  PrefView.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 20.01.22.
//

import SwiftUI

struct PrefView: View {
    @EnvironmentObject private var sc: StateController
    
    var body: some View { Content(startDate: sc.preferences.startDate, edit: edit) }
    
    private func edit(_ startDate: Date? = nil) {
        try? sc.editPreferences(startDate: startDate) //TODO: implement error handling
    }
}

/*
 //MARK: ideas for settable preferences
 
 - start date
 - import / export (JSON)
 - cloud storage
 - default number of cigarettes to add per click
 - ...
 
 */
