//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Cocoa
import IOKit.ps

final class BatteryMonitor {
    
    private var onChange: (() -> Void)?
    private var runLoopSource: CFRunLoopSource?
    
    func start(onChange: @escaping () -> Void) {
        if runLoopSource != nil {
            stop()
        }
        
        self.onChange = onChange
        
        let callback: IOPowerSourceCallbackType = { context in
            let this = Unmanaged<BatteryMonitor>.fromOpaque(UnsafeRawPointer(context)!).takeUnretainedValue()
            this.onChange?()
        }
        
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
        onChange = nil
    }
}
