//
//  InfoView.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 12.10.21.
//

import SwiftUI
import MyLayout
import MyCustomUI

struct InfoView: View {
    var body: some View {
        ScrollView {
            Section {
                Text("Hi, my name's Leo. Ashtray has been my project for a while now. It started out as something I was missing on my iPhone: A way to gain insight into my smoking habit. I had pretty much just started out learning to program for iOS and this was a great project to practice my skills on.")
                    .font(size: 15)
                    .multilineTextAlignment(.center)
                    .layoutListItem(height: LayoutDefaults.rowHeight * 4)
            } header: {
                Text("Info")
                    .font(size: 15)
            }
            
            Section {
                Text("...")
                    .font(size: 15)
                    .layoutListItem()
            } header: {
                Text("Credits")
                    .font(size: 15)
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
            .preview()
    }
}
