//
//  PanelController.swift
//  Appolon
//
//  Created by Fedi Nabli on 18/4/2026.
//

import AppKit
import SwiftUI
import SwiftData
import KeyboardShortcuts

@MainActor
final class PanelController {
    private var panel: FloatingPanel?
    
    /// UserDefaults key for persisting the panel frame between launches
    private let frameDefaultsKey = "appolon.panelFrame"
    
    /// Default size if no persisted frame exists
    private let defaultSize = NSSize(width: 440, height: 680)
    
    /// Margin from top-right corner of the active screen on first open
    private let topRightMargin: CGFloat = 20
    
    init() {
        registerShortcuts()
    }
    
    func toggle() {
        if let panel, panel.isVisible {
            panel.orderOut(nil)
        } else {
            show()
        }
    }
    
    func toggleFocused() {
        if let panel, panel.isVisible {
            panel.orderOut(nil)
        } else {
            showAndFocus()
        }
    }
    
    func show() {
        let panel = panel ?? makePanel()
        self.panel = panel
        panel.orderFrontRegardless()
    }
    
    func showAndFocus() {
        let panel = panel ?? makePanel()
        self.panel = panel
        panel.orderFrontRegardless()
        panel.makeKey()
    }
    
    func hide() {
        panel?.orderOut(nil)
    }
    
    private func registerShortcuts() {
        KeyboardShortcuts.onKeyDown(for: .togglePanel) { [weak self] in
            self?.toggle()
        }
        
        KeyboardShortcuts.onKeyDown(for: .togglePanelFocused) { [weak self] in
            self?.toggleFocused()
        }
    }
    
    private func makePanel() -> FloatingPanel {
        let initialFrame = loadFrame() ?? defaultFrame()
        let panel = FloatingPanel(contentRect: initialFrame)
        panel.setFrame(initialFrame, display: false)
        panel.delegate = panelDelegate
        
        let root = PanelRootView()
            .modelContainer(AppolonModelContainer.shared)
        panel.contentViewController = NSHostingController(rootView: root)
        
        return panel
    }
    
    private func defaultFrame() -> NSRect {
        // Prefer the screen currently the mouse cursor, that's usually where the
        // user is working
        let screen = NSScreen.screenWithMouse ?? NSScreen.main ?? NSScreen.screens.first!
        let visible = screen.visibleFrame // excludes Dock and menu bar
        
        let size = defaultSize
        let x = visible.maxX - size.width - topRightMargin
        let y = visible.maxY - size.height - topRightMargin
        return NSRect(x: x, y: y, width: size.width, height: size.height)
    }
    
    private func loadFrame() -> NSRect? {
        guard let dict = UserDefaults.standard.dictionary(forKey: frameDefaultsKey),
              let x = dict["x"] as? CGFloat,
              let y = dict["y"] as? CGFloat,
              let w = dict["w"] as? CGFloat,
              let h = dict["h"] as? CGFloat else {
            return nil
        }
        
        let frame = NSRect(x: x, y: y, width: w, height: h)
        
        // Sanity check: make sure frame still fits on some screen
        // Screens can disappear (e.g. unplugged monitor), if the saved frame
        // is entirely off screen, fall back to default
        guard NSScreen.screens.contains(where: { $0.frame.intersects(frame) }) else {
            return nil
        }
        
        return frame
    }
    
    private func saveFrame(_ frame: NSRect) {
        let dict: [String: CGFloat] = [
            "x": frame.origin.x,
            "y": frame.origin.y,
            "w": frame.size.width,
            "h": frame.size.height
        ]
        
        UserDefaults.standard.set(dict, forKey: frameDefaultsKey)
    }
    
    // Single delegate instance shared by the panel, keeps self referenced
    // via the closure in NotificationCenter observers below
    private lazy var panelDelegate: PanelDelegate = {
        PanelDelegate(onFrameChange: { [weak self] frame in
            self?.saveFrame(frame)
        })
    }()
}

// The NSWindowDelegate that forwards frame changes back to the controller
private final class PanelDelegate: NSObject, NSWindowDelegate {
    let onFrameChange: (NSRect) -> Void
    
    init(onFrameChange: @escaping (NSRect) -> Void) {
        self.onFrameChange = onFrameChange
    }
    
    func windowDidMove(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        onFrameChange(window.frame)
    }
    
    func windowDidResize(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        onFrameChange(window.frame)
    }
}

private extension NSScreen {
    // The screen currently containing the mouse cursor if any
    static var screenWithMouse: NSScreen? {
        let mouse = NSEvent.mouseLocation
        return screens.first { $0.frame.contains(mouse) }
    }
}
