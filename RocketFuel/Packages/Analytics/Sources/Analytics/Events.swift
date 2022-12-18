//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import Mixpanel

public enum Event {
    case applicationDidLaunch
    case applicationWillTerminate
    case error(Error)
    case showAbout
    case showSettings
    case toggle(status: Bool, duration: TimeInterval)
    case update(setting: String, value: CustomStringConvertible)
    case developerSettingsTest
    
    var name: String {
        switch self {
        case .applicationDidLaunch:
            return "launch"
        case .applicationWillTerminate:
            return "terminate"
        case .error:
            return "error"
        case .showAbout:
            return "show about"
        case .showSettings:
            return "show settings"
        case .toggle:
            return "toggle"
        case .update:
            return "update setting"
        case .developerSettingsTest:
            return "developer settings test"
        }
    }
    
    var properties: Properties? {
        let properties: Properties
        
        switch self {
        case .error(let error):
            properties = ["error": error.localizedDescription]
        case .toggle(let status, let duration):
            properties = ["status": status, "duration": duration]
        case .update(let setting, let value):
            properties = ["setting": setting, "value": value.description]
        default:
            return nil
        }
        
        return properties
    }
}
