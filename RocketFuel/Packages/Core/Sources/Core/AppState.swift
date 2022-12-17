//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import HotKeys
import LoginItem
import UserInterfaces

public actor AppState: Settings {
    
    enum Event {
        case launch
        case change(Key, newValue: Codable)
    }
    
    enum Key: String {
        case registeredHotKey = "activationHotKey"
        case autoLaunchOnLogin = "launchAtLogin"
        case leftClickActivation = "leftClickActivation"
        case disableOnBatteryMode = "disableOnBatteryMode"
        case disableAtBatteryLevel = "stopAtBatteryLevel"
    }
    
    nonisolated static let shared = AppState()
    
    @Published var onChangePublisher: Event = .launch
    
    public private(set) var registeredHotKey: HotKey?
    public private(set) var isActive: Bool = false
    public private(set) var leftClickActivation: Bool
    public private(set) var disableOnBatteryMode: Bool
    public private(set) var disableAtBatteryLevel: Int
    
    public var autoLaunchOnLogin: Bool {
        if #available(macOS 13.0, *) {
            return loginItem.isEnabled
        } else {
            return userDefaults.bool(forKey: Key.autoLaunchOnLogin.rawValue)
        }
    }
    
    private let userDefaults: UserDefaults = .standard
    private let loginItem: LoginItem
    
    init() {
        if let data = userDefaults.object(forKey: Key.registeredHotKey.rawValue) as? Data {
            let decoder = JSONDecoder()
            registeredHotKey = try? decoder.decode(HotKey.self, from: data)
        }
        
        leftClickActivation = userDefaults.bool(forKey: Key.leftClickActivation.rawValue)
        disableOnBatteryMode = userDefaults.bool(forKey: Key.disableOnBatteryMode.rawValue)
        disableAtBatteryLevel = userDefaults.integer(forKey: Key.disableAtBatteryLevel.rawValue)
        
        let bundleIdentifier = Bundle.main.bundleIdentifier?.appending(".Launcher") ?? ""
        loginItem = LoginItem(bundleIdentifier: bundleIdentifier)
    }
    
    public func setRegisteredHotKey(to value: HotKey?) {
        registeredHotKey = value
        
        guard let value else {
            set(registeredHotKey, forKey: .registeredHotKey)
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(value)
            set(data, forKey: .registeredHotKey)
        } catch {
            print("Unexpected error. Could not set value (\(value)) for key \(Key.registeredHotKey)")
        }
    }
    
    public func setAutoLaunchOnLogin(to value: Bool) async {
        loginItem.enable(value)
        set(value, forKey: .autoLaunchOnLogin)
    }
    
    public func setLeftClickActivation(to value: Bool) async {
        leftClickActivation = value
        set(value, forKey: .leftClickActivation)
    }
    
    public func setDisableOnBatteryMode(to value: Bool) async {
        disableOnBatteryMode = value
        set(value, forKey: .disableOnBatteryMode)
    }
    
    public func setDisableAtBatteryLevel(to value: Int) async {
        disableAtBatteryLevel = value
        set(value, forKey: .disableAtBatteryLevel)
    }
    
    private func set<V: Codable>(_ value: V, forKey key: Key) {
        userDefaults.set(value, forKey: key.rawValue)
        onChangePublisher = .change(key, newValue: value)
    }
}
