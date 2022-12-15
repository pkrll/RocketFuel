//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation

public final class SleepControl {
    
    @Published public private(set) var isActive = false
    
    private let assertionManager: AssertionManager
    private var timer: Timer?
    
    public convenience init() {
        self.init(assertionManager: AssertionManager())
    }
    
    init(assertionManager: AssertionManager) {
        self.assertionManager = assertionManager
    }
    /// Enable sleep prevention.
    @discardableResult
    public func enable(duration: TimeInterval = 0) -> Bool {
        isActive = assertionManager.create(.preventIdleDisplaySleep, timeout: duration as CFTimeInterval)
        
        guard isActive, duration > 0 else {
            return false
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.isActive = false
        }

        return isActive
    }
    /// Disable sleep prevention.
    public func disable() {
        assertionManager.clear()
        isActive = false
    }
}
