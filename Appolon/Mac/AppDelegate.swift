//
//  AppDelegate.swift
//  Appolon
//
//  Created by Fedi Nabli on 17/4/2026.
//

import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItemController: StatusItemController?
    private var panelController: PanelController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // .accessory = no Dock icon, no global menu bar, background style app
        NSApp.setActivationPolicy(.accessory)
        
        let panel = PanelController()
        let statusItem = StatusItemController(
            onOpenPanel: { [weak panel] in panel?.toggle() }
        )
        
        self.panelController = panel
        self.statusItemController = statusItem
    }
    
    // Menu bar app shouldn't quit just because a window closed
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }
}
