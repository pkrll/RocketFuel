//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import AppIntents
import SleepControl

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct Toggle: AppIntent {
    
    static var title: LocalizedStringResource = "Activate/Deactivate"
    static var description = IntentDescription("Activates or deactivates Rocket Fuel.")
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
        
        return .result(value: toggleValue)
    }
}
