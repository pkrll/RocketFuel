//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Cocoa
import IOKit.ps

final class BatteryMonitor {
    
    private var runLoopSource: CFRunLoopSource?
    
    func start(callback: IOPowerSourceCallbackType) {
        let pointerToSelf = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        runLoopSource = IOPSNotificationCreateRunLoopSource(callback, pointerToSelf).takeUnretainedValue()
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .defaultMode)
    }
    
    func stop() {
        guard let runLoopSource else {
            return
        }
        
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .defaultMode)
        self.runLoopSource = nil
    }
}
