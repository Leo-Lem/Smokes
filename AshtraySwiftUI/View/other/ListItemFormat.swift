//
//  ListItemFormat.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 16.12.21.
//

import SwiftUI
import MyLayout

struct ListItemFormat: ViewModifier {
    let color: Color, cornerRadius: CGFloat, shadowRadius: CGFloat, shadowOffset: CGFloat, height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: height)
            .background(
                color
                    .cornerRadius(cornerRadius)
                    .shadow(color: Color.black, radius: shadowRadius, y: shadowOffset)
            )
            .padding(.horizontal)
    }
}

extension View {
    func layoutListItem(color: Color = Color("BackgroundColor"),
                        cornerRadius: CGFloat = LayoutDefaults.cornerRadius,
                        shadowRadius: CGFloat = LayoutDefaults.shadowRadius,
                        shadowOffset: CGFloat = LayoutDefaults.shadowOffset,
                        height: CGFloat = LayoutDefaults.rowHeight) -> some View {
        self.modifier(
            ListItemFormat(color: color, cornerRadius: cornerRadius, shadowRadius: shadowRadius, shadowOffset: shadowOffset, height: height)
        )
    }
}
