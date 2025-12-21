//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import AppKit
import Carbon

// MARK: - HotKey Model

struct HotKey: Codable, Equatable, Sendable {
    let keyCode: Int
    let modifier: Int
    let readable: String

    var id: Int { keyCode }
}

// MARK: - HotKeyManager

final class HotKeyManager: @unchecked Sendable {
    var onHotKeyPressed: ((HotKey) -> Void)?

    private var registeredHotKeys: [Int: HotKey] = [:]
    private var hotKeyRefs: [Int: EventHotKeyRef] = [:]

    init() {
        installEventHandler()
    }

    func register(_ hotKey: HotKey) throws {
        guard hotKey.id > -1, registeredHotKeys[hotKey.id] == nil else { return }

        var hotKeyRef: EventHotKeyRef?
        var hotKeyID = EventHotKeyID()

        hotKeyID.id = UInt32(hotKey.id)
        hotKeyID.signature = UTGetOSTypeFromString("RKFL" as CFString)

        let status = RegisterEventHotKey(
            UInt32(hotKey.keyCode),
            UInt32(hotKey.modifier),
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )

        guard status == noErr else {
            throw HotKeyError.registrationFailed(status)
        }

        registeredHotKeys[hotKey.id] = hotKey
        hotKeyRefs[hotKey.id] = hotKeyRef
    }

    func unregister(_ hotKey: HotKey) throws {
        guard let hotKeyRef = hotKeyRefs[hotKey.id] else { return }

        let status = UnregisterEventHotKey(hotKeyRef)
        guard status == noErr else {
            throw HotKeyError.unregistrationFailed(status)
        }

        registeredHotKeys.removeValue(forKey: hotKey.id)
        hotKeyRefs.removeValue(forKey: hotKey.id)
    }

    private func installEventHandler() {
        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: OSType(kEventHotKeyPressed)
        )

        let handler: EventHandlerUPP = { _, event, _ in
            HotKeyManager.handleEvent(event)
        }

        InstallEventHandler(
            GetApplicationEventTarget(),
            handler,
            1,
            &eventType,
            nil,
            nil
        )
    }

    private static func handleEvent(_ event: EventRef?) -> OSStatus {
        guard let event, Int(GetEventClass(event)) == kEventClassKeyboard else {
            return OSStatus(eventNotHandledErr)
        }

        var hotKeyID = EventHotKeyID()
        let status = GetEventParameter(
            event,
            EventParamName(kEventParamDirectObject),
            EventParamType(typeEventHotKeyID),
            nil,
            MemoryLayout<EventHotKeyID>.size,
            nil,
            &hotKeyID
        )

        guard status == noErr else { return status }

        NotificationCenter.default.post(
            name: .hotKeyPressed,
            object: nil,
            userInfo: ["id": Int(hotKeyID.id)]
        )

        return noErr
    }
}

// MARK: - Notification Extension

extension Notification.Name {
    static let hotKeyPressed = Notification.Name("HotKeyPressed")
}

// MARK: - Error

enum HotKeyError: Error {
    case registrationFailed(OSStatus)
    case unregistrationFailed(OSStatus)
}

// MARK: - HotKey Helpers

extension HotKey {
    static func from(event: NSEvent) -> HotKey? {
        guard let character = event.charactersIgnoringModifiers?.uppercased() else {
            return nil
        }

        let keyCode = Int(event.keyCode)
        var modifier = 0
        var readable = ""

        if event.modifierFlags.contains(.control) {
            readable += "^"
            modifier |= controlKey
        }

        if event.modifierFlags.contains(.option) {
            readable += "⌥"
            modifier |= optionKey
        }

        if event.modifierFlags.contains(.shift) {
            readable += "⇧"
            modifier |= shiftKey
        }

        if event.modifierFlags.contains(.command) {
            readable += "⌘"
            modifier |= cmdKey
        }

        readable += character

        return HotKey(keyCode: keyCode, modifier: modifier, readable: readable)
    }
}
