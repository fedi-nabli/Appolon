//
//  PriorityDot.swift
//  Appolon
//
//  Created by Fedi Nabli on 18/4/2026.
//

import SwiftUI

struct PriorityDot: View {
    let priority: Priority
    var size: CGFloat = 8
    
    var body: some View {
        Circle()
            .fill(priority.color)
            .frame(width: size, height: size)
            .overlay(
                Circle()
                    .stroke(Color.primary.opacity(0.08), lineWidth: 0.5)
            )
    }
}
