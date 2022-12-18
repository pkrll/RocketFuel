//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import Mixpanel

extension AppState {
    var analyticsValue: Properties {[
        "hotKey": registeredHotKey?.rawValue ?? "None",
        "launchAtLogin": autoLaunchOnLogin,
        "leftClickActivation": leftClickActivation,
        "disableOnBatteryMode": disableOnBatteryMode,
        "disableAtBatteryLevel": disableAtBatteryLevel
    ]}
}
