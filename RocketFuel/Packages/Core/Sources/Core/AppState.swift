//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import HotKeys

actor AppState {
    
    private(set) var registeredHotKey: HotKey?
    private(set) var isActive: Bool = false
    private(set) var leftClickActivation: Bool
    private(set) var disableOnBatteryMode: Bool
    private(set) var disableAtBatteryLevel: Int
    
    private let userDefaults: UserDefaults = .standard
    
    init() {
        registeredHotKey = userDefaults.object(forKey: .registeredHotKey) as? HotKey
        leftClickActivation = userDefaults.bool(forKey: .leftClickActivation)
        disableOnBatteryMode = userDefaults.bool(forKey: .disableOnBatteryMode)
        disableAtBatteryLevel = userDefaults.integer(forKey: .disableAtBatteryLevel)
    }
    
    func setRegisteredHotKey(to value: HotKey?) {
        registeredHotKey = value
        set(value, forKey: .registeredHotKey)
    }
    
    func setLeftClickActivation(to value: Bool) async {
        leftClickActivation = value
        set(value, forKey: .leftClickActivation)
    }
    
    func setDisableOnBatteryMode(to value: Bool) async {
        disableOnBatteryMode = value
        set(value, forKey: .disableOnBatteryMode)
    }
    
    func setDisableAtBatteryLevel(to value: Int) async {
        disableAtBatteryLevel = value
        set(value, forKey: .disableAtBatteryLevel)
    }
    
    private func set<V: Codable>(_ value: V, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
}

private extension String {
    static let registeredHotKey = "activationHotKey"
    static let leftClickActivation = "leftClickActivation"
    static let disableOnBatteryMode = "disableOnBatteryMode"
    static let disableAtBatteryLevel = "stopAtBatteryLevel"
}
