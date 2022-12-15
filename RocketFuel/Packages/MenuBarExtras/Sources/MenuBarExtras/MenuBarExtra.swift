//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Cocoa

@MainActor
public final class MenuBarExtra {
    
    public let toolTip: String
    
    private let rightClickEvent: (NSEvent.ModifierFlags) async throws -> Void
    private let leftClickEvent: (NSEvent.ModifierFlags) async throws-> Void
    private let statusItem: NSStatusItem
    
    public init(
        toolTip: String,
        leftClickEvent: @escaping (NSEvent.ModifierFlags) async throws -> Void,
        rightClickEvent: @escaping (NSEvent.ModifierFlags) async throws -> Void
    ) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.leftClickEvent = leftClickEvent
        self.rightClickEvent = rightClickEvent
        self.toolTip = toolTip
        
        guard let button = statusItem.button else {
            return
        }
        
        button.toolTip = toolTip
        button.target = self
        button.action = #selector(didTapButton(_:))
        button.sendAction(on: .leftAndRightMouseUp)
    }
    
    @objc
    private func didTapButton(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else {
            return
        }

        Task {
            switch event.type {
            case .leftMouseUp:
                try await leftClickEvent(event.modifierFlags)
            case .rightMouseUp:
                try await rightClickEvent(event.modifierFlags)
            default:
                fatalError("Unexpected event type: \(event.type).")
            }
        }
    }
    
    public func show(menu: NSMenu) {
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
    }
    
    public func set(image: NSImage?) {
        statusItem.button?.image = image
    }
}

private extension NSEvent.EventTypeMask {
    static let leftAndRightMouseUp = Self(rawValue: leftMouseUp.rawValue | rightMouseUp.rawValue)
}

