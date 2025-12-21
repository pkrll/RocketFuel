//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import Foundation
import IOKit.ps

final class BatteryMonitor: @unchecked Sendable {
    var onChange: (() -> Void)?

    private var runLoopSource: CFRunLoopSource?

    var isOnBattery: Bool {
        let blob = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(blob).takeRetainedValue() as Array

        for source in sources {
            let description = IOPSGetPowerSourceDescription(blob, source).takeUnretainedValue() as NSDictionary

            guard let powerSource = description[kIOPSPowerSourceStateKey] as? String else {
                continue
            }

            return powerSource == kIOPSBatteryPowerValue
        }

        return false
    }

    var currentCharge: Int {
        let blob = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(blob).takeRetainedValue() as Array

        for source in sources {
            let description = IOPSGetPowerSourceDescription(blob, source).takeUnretainedValue() as NSDictionary

            guard let currentCapacity = description[kIOPSCurrentCapacityKey] as? Double,
                  let maxCapacity = description[kIOPSMaxCapacityKey] as? Double
            else {
                continue
            }

            return Int((currentCapacity / maxCapacity) * 100.0)
        }

        return 100
    }

    func start() {
        guard runLoopSource == nil else { return }

        let callback: IOPowerSourceCallbackType = { context in
            guard let context else { return }
            let monitor = Unmanaged<BatteryMonitor>.fromOpaque(context).takeUnretainedValue()
            monitor.onChange?()
        }

        let pointer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        runLoopSource = IOPSNotificationCreateRunLoopSource(callback, pointer).takeRetainedValue()

        if let runLoopSource {
            CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .defaultMode)
        }
    }

    func stop() {
        guard let runLoopSource else { return }
        CFRunLoopRemoveSource(CFRunLoopGetMain(), runLoopSource, .defaultMode)
        self.runLoopSource = nil
    }

    deinit {
        stop()
    }
}
