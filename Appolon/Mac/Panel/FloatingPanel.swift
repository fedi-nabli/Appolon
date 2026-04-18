//
//  FloatingPanel.swift
//  Appolon
//
//  Created by Fedi Nabli on 18/4/2026.
//

import AppKit

// non activating HUD panel that floats above regular windows
final class FloatingPanel: NSPanel {
    init(contentRect: NSRect) {
        super.init(
            contentRect: contentRect,
            styleMask: [
                .titled,
                .closable,
                .resizable,
                .fullSizeContentView,
                .nonactivatingPanel,
                .hudWindow
            ],
            backing: .buffered,
            defer: false
        )
        
        // Appearance: titlebar blends into content
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.isMovableByWindowBackground = true
        
        // Behavior
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        self.hidesOnDeactivate = false
        self.isReleasedWhenClosed = false
        self.hasShadow = true
        
        // Standard traffic light button: hide close/minimize/zoom
        // Escape or shortcut closes the panel
        self.standardWindowButton(.closeButton)?.isHidden = true
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true
        
        self.minSize = NSSize(width: 360, height: 480)
    }
    
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
    
    override func cancelOperation(_ sender: Any?) {
        self.orderOut(nil)
    }
}
