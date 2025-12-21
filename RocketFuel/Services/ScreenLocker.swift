//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

@preconcurrency import ApplicationServices
import Foundation

enum ScreenLocker {
    static var hasAccessibilityPermission: Bool {
        AXIsProcessTrusted()
    }

    static func requestAccessibilityPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true] as CFDictionary
        AXIsProcessTrustedWithOptions(options)
    }

    static func lock() {
        guard hasAccessibilityPermission else { return }

        if let keyDown = CGEvent(keyboardEventSource: nil, virtualKey: 0x0C, keyDown: true) {
            keyDown.flags = [.maskCommand, .maskControl]
            keyDown.post(tap: .cghidEventTap)
        }

        if let keyUp = CGEvent(keyboardEventSource: nil, virtualKey: 0x0C, keyDown: false) {
            keyUp.flags = [.maskCommand, .maskControl]
            keyUp.post(tap: .cghidEventTap)
        }
    }
}
