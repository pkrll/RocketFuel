//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Cocoa
import IOKit.pwr_mgt

final class AssertionManager {
    enum Assertion: String {
        case preventIdleDisplaySleep
        case preventIdleSystemSleep
        
        var rawValue: String {
            switch self {
            case .preventIdleDisplaySleep:
                return kIOPMAssertPreventUserIdleDisplaySleep
            case .preventIdleSystemSleep:
                return kIOPMAssertPreventUserIdleSystemSleep
            }
        }
    }
    
    private(set) var assertionId: IOPMAssertionID = .zero
    private(set) var assertion: IOReturn = 0
    
    private var isActive: Bool { assertionId != IOPMAssertionID(0) }
    
    func create(_ assertion: Assertion, timeout: CFTimeInterval) -> Bool {
        if isActive {
            clear()
        }
        
        let type = assertion.rawValue as CFString
        let name = "S5SleepControl" as CFString
        let timeoutAction = kIOPMAssertionTimeoutActionRelease as CFString
        self.assertion = IOPMAssertionCreateWithDescription(
            type, name, nil, nil, nil, timeout, timeoutAction, &assertionId
        )
        
        return self.assertion == kIOReturnSuccess
    }
    
    func clear() {
        guard isActive else {
            return
        }
        
        assertion = IOPMAssertionRelease(assertionId)
        assertionId = .zero
    }
}
