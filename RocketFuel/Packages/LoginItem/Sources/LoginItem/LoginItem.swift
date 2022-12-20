//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import ServiceManagement

public struct LoginItem {
    
    @available(macOS 13.0, *)
    public var isEnabled: Bool {
        guard case .enabled = item.status else {
            return false
        }
        
        return true
    }
    
    private let bundleIdentifier: String
    
    @available(macOS 13.0, *)
    private var item: SMAppService {
        SMAppService.loginItem(identifier: bundleIdentifier)
    }
    
    public init(bundleIdentifier: String) {
        self.bundleIdentifier = bundleIdentifier
    }
    
    @discardableResult
    public func enable(_ shouldEnable: Bool) -> Bool {
        guard #available(macOS 13.0, *) else {
            return _enable_legacy(shouldEnable)
        }
        
        do {
            if shouldEnable {
                try item.register()
            } else {
                try item.unregister()
            }
        } catch {
            print("Could not register/unregister login item: \(error.localizedDescription)")
            return false
        }
        
        return true
    }
    
    private func _enable_legacy(_ shouldEnable: Bool) -> Bool {
        SMLoginItemSetEnabled(bundleIdentifier as CFString, shouldEnable)
    }
}
