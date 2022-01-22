//
//  Row-Modifier.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 22.01.22.
//

import SwiftUI
import MyCustomUI

struct Row: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .background(.bar)
            .cornerRadius(10)
            .padding(.horizontal)
            .shadow(color: .accentColor, radius: 3, x: 3, y: 3)
            .font("default-font"~, size: 25)
    }
}

extension View {
    func rowItem() -> some View {
        self.modifier(Row())
    }
}
