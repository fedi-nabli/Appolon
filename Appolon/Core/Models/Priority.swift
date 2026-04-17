//
//  Priority.swift
//  Appolon
//
//  Created by Fedi Nabli on 16/4/2026.
//

import SwiftUI

enum Priority: Int, Codable, CaseIterable, Identifiable {
    case lowest = 0
    case low = 1
    case medium = 2
    case high = 3
    case highest = 4
    
    var id: Int { rawValue }
    
    var color: Color {
        switch self {
        case .lowest: Color(red: 0.56, green: 0.56, blue: 0.58) // gray #8E8E93
        case .low: Color(red: 0.20, green: 0.78, blue: 0.35) // green #34C759
        case .medium: Color(red: 1.00, green: 0.80, blue: 0.00) // yellow #FFCC00
        case .high: Color(red: 1.00, green: 0.58, blue: 0.00) // orange #FF9500
        case .highest: Color(red: 1.00, green: 0.23, blue: 0.19) // red #FF3B30
        }
    }
    
    var shortLabel: String { "P\(rawValue)" }
}
