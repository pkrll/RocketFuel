//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import IOKit.pwr_mgt

public final class SleepControl {
    /// The shared SleepControl object.
    ///
    /// Note: When invoking this app via an AppleScript, the running instance
    /// will not react on any changes. Shared state must be global.
    public static let standard = SleepControl()
    
    @Published public private(set) var isActive = false
    
    private let assertionManager: AssertionManager
    private let batteryMonitor: BatteryMonitor
    private var shouldStopOnBatteryMode = false
    private var minimumBatteryLevel = 0
    private var timer: Timer?
    
    public convenience init() {
        self.init(assertionManager: AssertionManager(), batteryMonitor: BatteryMonitor())
    }
    
    init(assertionManager: AssertionManager, batteryMonitor: BatteryMonitor) {
        self.assertionManager = assertionManager
        self.batteryMonitor = batteryMonitor
        batteryMonitor.start(onChange: disableIfNeeded)
    }
    /// Enable sleep prevention.
    @discardableResult
    public func enable(
        duration: TimeInterval = 0,
        shouldStopOnBatteryMode: Bool,
        minimumBatteryLevel: Int
    ) -> Bool {
        // Ignore shouldStopOnBatteryMode parameter if activated while on battery mode
        self.shouldStopOnBatteryMode = shouldStopOnBatteryMode && !PowerSource.onBatteryPower
        self.minimumBatteryLevel = minimumBatteryLevel
        
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
    
    private func disableIfNeeded() {
        guard isActive else {
            return
        }
        
        do {
            let hasSwitchedToBattery = shouldStopOnBatteryMode && PowerSource.onBatteryPower
            let batteryLevelIsBelowLimit = try PowerSource.currentCharge < minimumBatteryLevel
            
            guard batteryLevelIsBelowLimit || hasSwitchedToBattery else {
                return
            }
        } catch {
            print("Unexpected error. Power sources not available: \(error.localizedDescription)")
        }
        
        disable()
    }
}
