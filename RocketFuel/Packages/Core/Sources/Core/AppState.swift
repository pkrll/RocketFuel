//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation

actor AppState {

    static let shared = AppState()
    
    var isActive: Bool = false
    var leftClickActivation: Bool = false
    var disableOnBatteryMode: Bool = true
    var stopAtBatteryLevel: Int = 0
    
    func toggleActiveState() async -> Bool {
        isActive.toggle()
        return isActive
    }
    
    func setLeftClickActivation(to value: Bool) async {
        leftClickActivation = value
    }
    
    func setDisableOnBatteryMode(to value: Bool) async {
        disableOnBatteryMode = value
    }
    
    func setStopAtBatteryLevel(to value: Int) async {
        stopAtBatteryLevel = value
    }
}
