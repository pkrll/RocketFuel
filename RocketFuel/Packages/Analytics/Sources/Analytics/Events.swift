//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import Mixpanel

public enum Event {
    case toggle(status: Bool, duration: TimeInterval)
    
    var name: String {
        switch self {
        case .toggle:
            return "toggle"
        }
    }
    
    var properties: Properties? {
        switch self {
        case .toggle(let status, let duration):
            return ["status": status, "duration": duration]
        }
    }
}
