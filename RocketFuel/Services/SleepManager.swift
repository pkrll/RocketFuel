//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import Foundation
import IOKit.pwr_mgt
import IOKit

final class SleepManager: @unchecked Sendable {
    private var assertionID: IOPMAssertionID = .zero
    private var isAssertionActive: Bool { assertionID != .zero }
    private var isOnACPower: Bool {
        let blob = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(blob).takeRetainedValue() as Array

        for source in sources {
            let description = IOPSGetPowerSourceDescription(blob, source).takeUnretainedValue() as NSDictionary

            guard let powerSource = description[kIOPSPowerSourceStateKey] as? String else {
                continue
            }

            return powerSource != kIOPSBatteryPowerValue
        }

        return true
    }

    func enable(duration: TimeInterval = 0) {
        if isAssertionActive {
            disable()
        }

        let type = kIOPMAssertPreventUserIdleDisplaySleep as CFString
        let name = "RocketFuel" as CFString
        let timeout = duration as CFTimeInterval
        let timeoutAction = kIOPMAssertionTimeoutActionRelease as CFString

        IOPMAssertionCreateWithDescription(
            type,
            name,
            nil,
            nil,
            nil,
            timeout,
            timeoutAction,
            &assertionID
        )
    }

    func disable() {
        guard isAssertionActive else { return }
        IOPMAssertionRelease(assertionID)
        assertionID = .zero
    }

    func getDisplaySleepMinutes() -> Int? {
        let powerSourceKey = isOnACPower ? "AC Power" : "Battery Power"

        let domains = [
            "com.apple.PowerManagement",
            "com.apple.systempreferences.energysaver",
            "/Library/Preferences/SystemConfiguration/com.apple.PowerManagement"
        ]

        for domain in domains {
            if let plist = CFPreferencesCopyValue(
                powerSourceKey as CFString,
                domain as CFString,
                kCFPreferencesAnyUser,
                kCFPreferencesCurrentHost
            ) as? [String: Any] {
                if let displaySleep = plist["Display Sleep Timer"] as? Int {
                    return displaySleep
                }
            }
        }

        return nil
    }
}
