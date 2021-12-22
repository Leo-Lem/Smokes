//
//  Preview Code.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 13.11.21.
//

import SwiftUI
import MyLayout

///acceptable previews
struct PreviewMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(.dark)
            .backgroundImage()
            .environmentObject(SuperViewModel())
    }
}

extension View {
    func preview() -> some View { self.modifier(PreviewMod()) }
}
