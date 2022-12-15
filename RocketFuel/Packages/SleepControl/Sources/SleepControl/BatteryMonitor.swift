//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Cocoa
import IOKit.ps

public final class BatteryMonitor {
    
    private let callback: IOPowerSourceCallbackType
    private var runLoopSource: CFRunLoopSource?
    
    public init(callback: IOPowerSourceCallbackType) {
        self.callback = callback
    }
    
    public func start() {
        let pointerToSelf = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        runLoopSource = IOPSNotificationCreateRunLoopSource(callback, pointerToSelf).takeUnretainedValue()
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .defaultMode)
    }
    
    public func stop() {
        guard let runLoopSource else {
            return
        }
        
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .defaultMode)
        self.runLoopSource = nil
    }
}
