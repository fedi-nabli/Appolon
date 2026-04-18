//
//  AppShortcuts.swift
//  Appolon
//
//  Created by Fedi Nabli on 18/4/2026.
//

import AppKit
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    // Global shortcut to toggle the floating panel
    // Default: Command + Shift + Space, User customizable in settings
    static let togglePanel = Self(
        "togglePanel",
        default: .init(.space, modifiers: [.command, .shift])
    )
    
    // Toggle the floating panel and give it key focus
    // Default: Option + Shift + Space, User customizable in settings
    static let togglePanelFocused = Self (
        "togglePanelFocused",
        default: .init(.space, modifiers: [.option, .shift])
    )
}
