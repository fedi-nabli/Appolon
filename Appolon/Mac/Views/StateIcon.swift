//
//  StateIcon.swift
//  Appolon
//
//  Created by Fedi Nabli on 18/4/2026.
//

import SwiftUI

struct StateIcon: View {
    let state: TaskState
    
    private var color: Color {
        switch state {
        case .todo: .secondary
        case .inProgress: .accentColor
        case .done: .green
        }
    }
    
    var body: some View {
        Image(systemName: state.iconName)
            .font(.system(size: 14, weight: .regular))
            .foregroundStyle(color)
            .frame(width: 16, height: 16)
    }
}
