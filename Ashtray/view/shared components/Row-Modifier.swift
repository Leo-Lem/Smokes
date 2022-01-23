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
            .cornerRadius(20)
            .padding(.horizontal)
            .shadow(color: .black, radius: 10)
            .font("default-font"~, size: 25, padd: false)
            .padding(.vertical, 5)
    }
}

extension View {
    func rowItem() -> some View {
        self.modifier(Row())
    }
}
