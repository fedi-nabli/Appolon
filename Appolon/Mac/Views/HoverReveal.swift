//
//  HoverReveal.swift
//  Appolon
//
//  Created by Fedi Nabli on 19/4/2026.
//

import SwiftUI

struct HoverReveal: ViewModifier {
    let isVisible: Bool
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .animation(.easeInOut(duration: 0.12), value: isVisible)
            .allowsHitTesting(isVisible)
    }
}

extension View {
    func hoverReveal(_ isVisible: Bool) -> some View {
        modifier(HoverReveal(isVisible: isVisible))
    }
}
