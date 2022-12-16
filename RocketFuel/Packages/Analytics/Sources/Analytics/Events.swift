//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import Mixpanel

public enum Event {
    case showAbout
    case showPreferences
    case toggle(status: Bool, duration: TimeInterval)
    case update(setting: String, value: CustomStringConvertible)
    case terminate
    
    var name: String {
        switch self {
        case .showAbout:
            return "about"
        case .showPreferences:
            return "settings"
        case .toggle:
            return "toggle"
        case .update:
            return "update"
        case .terminate:
            return "terminate"
        }
    }
    
    var properties: Properties? {
        switch self {
        case .toggle(let status, let duration):
            return ["status": status, "duration": duration]
        case .update(let setting, let value):
            return ["setting": setting, "value": value.description]
        default:
            return nil
        }
    }
}
