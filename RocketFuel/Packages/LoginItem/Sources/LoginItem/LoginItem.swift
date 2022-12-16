//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import ServiceManagement

public struct LoginItem {
    
    @available(macOS 13.0, *)
    public var isEnabled: Bool {
        let item = SMAppService.loginItem(identifier: bundleIdentifier)
        
        guard case .enabled = item.status else {
            return false
        }
        
        return true
    }
    
    private let bundleIdentifier: String
    
    public init(bundleIdentifier: String) {
        self.bundleIdentifier = bundleIdentifier
    }
    
    @discardableResult
    public func enable(_ shouldEnable: Bool) -> Bool {
        let success = SMLoginItemSetEnabled(bundleIdentifier as CFString, shouldEnable)
        
        return success
    }
}
