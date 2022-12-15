//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Carbon

public final class HotKeysCentral {
    public static let standard = HotKeysCentral()
    private var registeredHotKeys: [Int: HotKey] = [:]
    
    init() {
        configure()
    }
    
    private func configure() {
        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyPressed)
        
        let inHandler: EventHandlerUPP = { _, event, _ in
            guard let event else {
                return .zero
            }
            
            return HotKeysCentral.standard.handle(event: event)
        }
        
        InstallEventHandler(GetApplicationEventTarget(), inHandler, 1, &eventType, nil, nil)
    }
    
    private func handle(event: EventRef) -> OSStatus {
        guard Int(GetEventClass(event)) == kEventClassKeyboard else {
            return -1
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
        
        guard status == noErr else {
            return status
        }
        
        guard let hotKey = registeredHotKeys[Int(hotKeyID.id)] else {
            return -1
        }
        
        hotKey.action?()
        return status
    }
    
    public func register(_ hotKey: HotKey) throws {
        guard hotKey.id > -1,
              registeredHotKeys[hotKey.id] == nil
        else {
            return
        }
        
        var hotKey = hotKey
        var hotKeyRef: EventHotKeyRef? = nil
        var hotKeyID = EventHotKeyID()
        
        hotKeyID.id = UInt32(hotKey.id)
        hotKeyID.signature = UTGetOSTypeFromString("RKFL" as CFString)
        
        let status = RegisterEventHotKey(UInt32(hotKey.keyCode), UInt32(hotKey.modifier), hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
        
        guard status == noErr else {
            throw Error.from(status: status)
        }
        
        hotKey.hotKeyRef = hotKeyRef
        registeredHotKeys[hotKey.id] = hotKey
    }
    
    public func unregister(_ hotKey: HotKey) throws {
        guard let hotKey = registeredHotKeys[hotKey.id] else {
            return
        }
        
        let status = UnregisterEventHotKey(hotKey.hotKeyRef)
        guard status == noErr else {
            throw Error.from(status: status)
        }
        
        registeredHotKeys.removeValue(forKey: hotKey.id)
    }
}
