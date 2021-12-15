//
//  Preview Code.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 13.11.21.
//

import SwiftUI

///acceptable previews
struct PreviewMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(.dark)
            .backgroundImage()
            .environmentObject(AshtrayModel())
    }
}

extension View {
    func preview() -> some View { self.modifier(PreviewMod()) }
}
