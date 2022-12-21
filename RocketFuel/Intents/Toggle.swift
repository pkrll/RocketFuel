//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import AppIntents
import SleepControl

@available(macOS 13, *)
struct Toggle: AppIntent {
    
    static var title: LocalizedStringResource = "Toggle"
    static var description = IntentDescription("Activate or deactivate Rocket Fuel.")
    static var openAppWhenRun: Bool = true
    
    @Parameter(title: "Stop on Battery Mode")
    var shouldStopOnBatteryMode: Bool?
    
    @Parameter(title: "Stop on Battery Level")
    var minimumBatteryLevel: Int?
    
    @Parameter(title: "Deactivate After (minutes)")
    var duration: TimeInterval?
    
    @MainActor
    func perform() async throws -> some IntentResult & Sendable {
        let sleepControl = SleepControl.standard
        var toggleValue = true
        
        if sleepControl.isActive {
            sleepControl.disable()
        } else {
            toggleValue = sleepControl.enable(
                duration: duration ?? 0,
                shouldStopOnBatteryMode: shouldStopOnBatteryMode ?? false,
                minimumBatteryLevel: minimumBatteryLevel ?? 15
            )
        }
        
        let state = toggleValue ? "on" : "off"
        return .result(value: toggleValue, dialog: "Rocket Fuel is now \(state).")
    }
}
