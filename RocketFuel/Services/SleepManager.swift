//
//  Copyright © 2025 Ardalan Samimi. All rights reserved.
//

import Foundation
import IOKit.pwr_mgt

final class SleepManager: @unchecked Sendable {
    private var assertionID: IOPMAssertionID = .zero
    private var isAssertionActive: Bool { assertionID != .zero }

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
}
