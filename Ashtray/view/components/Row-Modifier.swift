//
//  Row-Modifier.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 22.01.22.
//

import SwiftUI

struct Row: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .background(.regularMaterial)
            .cornerRadius(10)
            .padding(.horizontal)
            .shadow(color: .secondary, radius: 5, y: 3)
            .font("default-font"~)
    }
}

extension View {
    func rowItem() -> some View {
        self.modifier(Row())
    }
}
