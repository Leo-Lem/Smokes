//
//  TwoWayDragButton.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 22.01.22.
//

import SwiftUI
import MyCustomUI

public struct TwoWayDragButton: View {
    let symbols: (String, String, String)
    let edge: Double, trigger: Double
    let actions: (() -> Void, () -> Void)
    
    public var body: some View {
        HStack {
            ZStack {
                Image(systemName: symbols.1)
                    .opacity(1 - abs(offset / trigger))
                Image(systemName: symbols.0)
                    .opacity(-offset / trigger)
                Image(systemName: symbols.2)
                    .opacity(offset / trigger)
            }
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged {
                        let drag = $0.translation.width
                        if -edge..<edge ~= drag { self.offset = $0.translation.width }
                    }
                    .onEnded {
                        let drag = $0.translation.width
                        if !(-trigger..<trigger ~= drag) { self.action() }
                        self.offset = 0
                    }
            )
        }
        .animation(offset)
    }
    
    private func action() {
        switch position {
        case .left: actions.0()
        case .right: actions.1()
        default: break
        }
    }
    
    @State private var offset = 0.0
    
    private enum Position { case left, center, right }
    private var position: Position {
        switch offset {
        case ..<(-trigger): return .left
        case trigger...: return .right
        default: return .center
        }
    }
    
    public init(symbols: (String, String, String) = ("minus.circle", "circle", "plus.circle"),
                edge: Double = 125, triggerAt: Double = 0.5,
                left: @escaping () -> Void, right: @escaping () -> Void) {
        self.symbols = symbols
        
        self.edge = edge
        self.trigger = triggerAt * edge
        
        self.actions = (left, right)
    }
}

//MARK: - Previews
struct TwoWayDragButton_Previews: PreviewProvider {
    static var previews: some View {
        TwoWayDragButton(left: { print("left") }, right: { print("right") })
        .font(.system(size: 50))
    }
}
