//
//  StatusItemController.swift
//  Appolon
//
//  Created by Fedi Nabli on 17/4/2026.
//

import AppKit
import SwiftUI
import SwiftData

final class StatusItemController: NSObject {
    private let statusItem: NSStatusItem
    private let popover: NSPopover
    private let onOpenPanel: () -> Void
    
    init(onOpenPanel: @escaping () -> Void) {
        self.onOpenPanel = onOpenPanel
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        self.popover = NSPopover()
        self.popover.contentSize = NSSize(width: 320, height: 440)
        self.popover.behavior = .transient // closes when user clicks away
        self.popover.animates = true
        
        super.init()
        
        configureButton()
        configurePopoverContent()
    }
    
    private func configureButton() {
        guard let button = statusItem.button else { return }
        button.image = NSImage(
            systemSymbolName: "checklist",
            accessibilityDescription: "Appolon"
        )
        button.target = self
        button.action = #selector(handleClick(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
    
    private func configurePopoverContent() {
        let root = PopoverView()
            .modelContainer(AppolonModelContainer.shared)
        popover.contentViewController = NSHostingController(rootView: root)
    }
    
    @objc private func handleClick(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .rightMouseUp {
            showContextMenu()
        } else {
            togglePopover()
        }
    }
    
    private func togglePopover() {
        if popover.isShown {
            popover.performClose(nil)
            return
        }
        
        guard let button = statusItem.button else { return }
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
    
    private func showContextMenu() {
        let menu = NSMenu()
        
        let openPanel = NSMenuItem(
            title: "Open Panel",
            action: #selector(menuOpenPanel),
            keyEquivalent: ""
        )
        openPanel.target = self
        menu.addItem(openPanel)
        
        let settings = NSMenuItem(
            title: "Settings",
            action: #selector(menuOpenSettings),
            keyEquivalent: ","
        )
        settings.target = self
        menu.addItem(settings)
        
        menu.addItem(.separator())
        
        let quit = NSMenuItem(
            title: "Quit Applolon",
            action: #selector(menuQuit),
            keyEquivalent: "q"
        )
        quit.target = self
        menu.addItem(quit)
        
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }
    
    @objc private func menuOpenPanel() {
        onOpenPanel()
        popover.performClose(nil) // close popover if it was open
    }
    
    @objc private func menuOpenSettings() {
        NSLog("Appolon: Open Settings stub")
    }
    
    @objc private func menuQuit() {
        NSApp.terminate(nil)
    }
}
