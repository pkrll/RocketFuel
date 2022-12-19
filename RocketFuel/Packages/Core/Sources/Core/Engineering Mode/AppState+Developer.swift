//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation

extension AppState {
    nonisolated var _shouldTrackEvents: Bool {
        get {
            guard let value = UserDefaults.standard.value(forKey: "_shouldTrackEvents") as? Bool else {
                return true
            }
            
            return value
        }
        set { UserDefaults.standard.set(newValue, forKey: "_shouldTrackEvents") }
    }
}
